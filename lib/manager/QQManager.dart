import 'dart:async';
import 'dart:convert';

import 'package:qq_robot_server/plugin/plugin.dart';
import 'package:qq_robot_server/plugin/steam.dart';
import 'package:qq_robot_server/plugin/switch.dart';
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
  ];

  ///发送出去消息缓存在这里 等待发送成功验证
  final Map _mapPendingMsg = {};

  init() async {
    if (_inited) return;
    _inited = true;

    _robotConnection = WebSocketChannel.connect(
      Uri.parse('$serverDomain/all'),
    );

    await for (var msg in receiveStream) {
      final receive = jsonDecode(msg);
      print('receive $receive');
      if (!_connected) {
        if ((receive['syncId'] == '') && (receive['data']['code'] == 0) && (receive['data']['session'] == 'SINGLE_SESSION')) {
          _connected = true;
          for (var plugin in _pluginList) {
            plugin.onInit();
            continue;
          }
        }
      }
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

  sendGroupMsg({required int target, required List messageChain}) async {
    return await send(command: 'sendGroupMessage', content: {'target': target, 'messageChain': messageChain});
  }

  sendFriendMsg({required int qq, required List messageChain}) async {
    return await send(command: 'sendFriendMessage', content: {'qq': qq, 'messageChain': messageChain});
  }

  fetchGroupMemberList({required int target}) async {
    return await send(command: 'memberList', content: {'target': target});
  }
}
