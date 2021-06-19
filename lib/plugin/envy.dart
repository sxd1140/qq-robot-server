import 'dart:convert';
import 'dart:io';

import 'package:qq_robot_server/Constant.dart';
import 'package:qq_robot_server/manager/QQManager.dart';
import 'package:qq_robot_server/model/message.dart';
import 'package:qq_robot_server/model/sender.dart';
import 'package:qq_robot_server/plugin/plugin.dart';
import 'package:qq_robot_server/util.dart';

class PluginEnvy extends Plugin {
  String KEY_WORD = '羡慕';
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
  onRecvMsg(Map msg) async {
    super.onRecvMsg(msg);
    if (msg.isGroupMessage) {
      final recvMsg = RecvGroupMessage.fromJson(msg);
      if ((recvMsg.sender as GroupMsgSender).group['id'] != installBGroupQQ) {
        return;
      }
      final contents = recvMsg.messageChain.whereType<MsgItemPlain>().toList();
      if (contents.length <= 0) return;

      //@机器人 羡慕 @要查询的人
      final ats = recvMsg.messageChain.whereType<MsgItemAt>().toList();
      if (ats.length >= 1) {
        if (ats[0].target == robotQQ) {
          String queryText = contents[0].text.trim();
          if (!queryText.startsWith(KEY_WORD)) return;
          final member = envyStore[ats[1].target.toString()];
          final queryMember = await QQManager().fetchGroupMemberProfile(groupID: installBGroupQQ, qq: ats[1].target);
          if (member == null) {
            replyMsg(recvMsg, buildPlainMsgItem('${queryMember.nickname}从不羡慕他人'));
          } else {
            replyMsg(recvMsg, buildPlainMsgItem('${queryMember.nickname}已经羡慕了${member['envyCount']}次'));
          }
          return;
        }
      }

      var content = '';
      contents.forEach((element) {
        content += element.text;
      });
      if (!content.contains(KEY_WORD)) return;

      final member = envyStore[recvMsg.sender.id.toString()] ?? {'envyCount': 0};
      member['envyCount'] = member['envyCount'] + 1;
      envyStore[recvMsg.sender.id.toString()] = member;
      fileEnvy.writeAsStringSync(jsonEncode(envyStore));
    }
  }
}
