import 'dart:convert';

import 'package:qq_robot_server/plugin/steam.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '/Constant.dart';

class QQManager {
  static final QQManager _singleton = QQManager._internal();

  factory QQManager() {
    return _singleton;
  }

  QQManager._internal();

  bool _inited = false;
  int syncIdForSend = 0;

  late WebSocketChannel _robotConnection;

  Stream get receiveStream => _robotConnection.stream;

  final List _pluginList = [pluginSteam];

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
      //验证消息发送成功
      final pendingMsg = _mapPendingMsg[receive['syncId']];
      if (pendingMsg != null) {
        if (receive['data']['messageId'] == -1) {
          print('发送失败, 重发.');
          send(command: pendingMsg['command'], content: pendingMsg['content']);
        }
        _mapPendingMsg.remove(receive['syncId']);
      } else {
        for (var plugin in _pluginList) {
          plugin(receive);
        }
      }
    }
  }

  send({required String command, Map? content}) {
    final payload = {
      'syncId': ++syncIdForSend,
      'command': command,
      'content': content,
    };
    _mapPendingMsg[syncIdForSend.toString()] = payload;
    _robotConnection.sink.add(jsonEncode(payload));
    print('send $payload');
  }

  sendGroupMsg({required int target, required List messageChain}) {
    send(command: 'sendGroupMessage', content: {'target': target, 'messageChain': messageChain});
  }

  sendFriendMsg({required int qq, required List messageChain}) {
    send(command: 'sendFriendMessage', content: {'qq': qq, 'messageChain': messageChain});
  }
}
