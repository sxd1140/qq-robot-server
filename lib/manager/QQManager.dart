import 'dart:async';
import 'dart:convert';

import 'package:qq_robot_server/model/model.dart';
import 'package:qq_robot_server/plugin/envy.dart';
import 'package:qq_robot_server/plugin/plugin.dart';
import 'package:qq_robot_server/plugin/steam.dart';
import 'package:qq_robot_server/plugin/switch.dart';
import 'package:qq_robot_server/slib.dart';
import 'package:qq_robot_server/util.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '/Constant.dart';

class QQManager {
  static final QQManager _singleton = QQManager._internal();

  factory QQManager() {
    return _singleton;
  }

  QQManager._internal();

  bool _inited = false;
  bool _connected = false;
  int syncIdForSend = 0;

  late WebSocketChannel _robotConnection;

  Stream get receiveStream => _robotConnection.stream;

  final List<Plugin> _pluginList = [
    PluginSteam(),
    PluginSwitch(),
    PluginEnvy(),
  ];

  ///发送出去消息缓存在这里 等待发送成功验证
  final Map _mapPendingMsg = {};

  init() async {
    if (_inited) return;
    _inited = true;

    _robotConnection = WebSocketChannel.connect(Uri.parse('$serverDomain/all?verifyKey=7SHbJwLH'));
    setInterval((t) {
      _robotConnection.sink.add('{}');
      // print('ping');
    }, 30 * 1000);

    await for (var msg in receiveStream) {
      final receive = jsonDecode(msg);
      print('receive $receive');
      if (!_connected) {
        if ((receive['syncId'] == '') && (receive['data']['code'] == 0) && (receive['data']['session'] == 'SINGLE_SESSION')) {
          _connected = true;
          for (var plugin in _pluginList) {
            plugin.onInit();
          }
          sendFriendMsg(qq: masterQQ, message: '机器人$robotQQ上线成功');
          continue;
        }
      }
      //{code:, msg:}
      if (receive['syncId'] == null) continue;
      //验证消息发送成功
      final pendingMsg = _mapPendingMsg[receive['syncId']];
      if (pendingMsg != null) {
        if (receive['data']['messageId'] == -1) {
          print('发送失败, 重发.');
          send(command: pendingMsg['payload']['command'], content: pendingMsg['payload']['content'], completer: pendingMsg['completer']);
        } else {
          pendingMsg['completer'].complete(receive);
        }
        _mapPendingMsg.remove(receive['syncId']);
      } else {
        for (var plugin in _pluginList) {
          plugin.onRecvMsg(receive);
        }
      }
    }
    print('end');
  }

  Future send({required String command, Map? content, Completer? completer}) {
    final payload = {
      'syncId': ++syncIdForSend,
      'command': command,
      'content': content,
    };
    completer ??= Completer();

    _mapPendingMsg[syncIdForSend.toString()] = {'payload': payload, 'completer': completer};
    _robotConnection.sink.add(jsonEncode(payload));
    print('send $payload');
    return completer.future;
  }

  sendGroupMsg({required int target, List? messageChain, String? message}) async {
    if (messageChain == null) {
      if (message == null) {
        print('sendGroupMsg no content');
        return;
      }
      messageChain = [buildPlainMsgItem(message)];
    }

    return await send(command: 'sendGroupMessage', content: {'target': target, 'messageChain': messageChain});
  }

  sendFriendMsg({required int qq, List? messageChain, String? message}) async {
    if (messageChain == null) {
      if (message == null) {
        print('sendFriendMsg no content');
        return;
      }
      messageChain = [buildPlainMsgItem(message)];
    }
    return await send(command: 'sendFriendMessage', content: {'qq': qq, 'messageChain': messageChain});
  }

  fetchGroupMemberList({required int target}) async {
    return await send(command: 'memberList', content: {'target': target});
  }

  Future<MemberProfile> fetchGroupMemberProfile({required int groupID, required int qq}) async {
    final result = await send(command: 'memberProfile', content: {'target': groupID, 'memberId': qq});
    return MemberProfile.fromJson(result);
  }
}
