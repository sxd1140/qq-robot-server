import 'dart:convert';
import 'dart:io';

import 'package:qq_robot_server/Constant.dart';
import 'package:qq_robot_server/model/Message.dart';
import 'package:qq_robot_server/model/Sender.dart';
import 'package:qq_robot_server/plugin/plugin.dart';

class PluginEnvy extends Plugin {
  var envyStore = {};
  late File fileEnvy;

  @override
  onInit() {
    super.onInit();
    fileEnvy = File('data/envy.json');
    if (fileEnvy.existsSync()) {
      envyStore = jsonDecode(fileEnvy.readAsStringSync());
    }
  }

  @override
  onRecvMsg(Map msg) {
    super.onRecvMsg(msg);
    if (msg.isGroupMessage) {
      final recvMsg = RecvGroupMessage.fromJson(msg);
      if ((recvMsg.sender as GroupMsgSender).group['id'] != '342854392') {
        return;
      }
      final member = envyStore[recvMsg.sender.id.toString()] ?? {'envyCount': 0};
      final item = recvMsg.messageChain.firstWhere((element) => (element is MsgItemPlain) && (element.text.contains('羡慕')), orElse: () => null);
      if (item == null) return;
      member['envyCount'] = member['envyCount'] + 1;
      envyStore[recvMsg.sender.id.toString()] = member;
      fileEnvy.writeAsStringSync(jsonEncode(envyStore));
    }
  }
}
