import 'package:qq_robot_server/Constant.dart';
import 'package:qq_robot_server/manager/DataManager.dart';
import 'package:qq_robot_server/manager/QQManager.dart';
import 'package:qq_robot_server/model/message.dart';
import 'package:qq_robot_server/model/sender.dart';
import 'package:qq_robot_server/plugin/plugin.dart';
import 'package:qq_robot_server/util.dart';

class PluginEnvy extends Plugin {
  String KEY_WORD = '羡慕';

  @override
  onInit() {
    super.onInit();
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

          final envyList = await DataManager().fetchLeanStorage(classes: 'envy', query: {'qq': ats[1].target});
          final envyStore = envyList[0];
          final queryMember = await QQManager().fetchGroupMemberProfile(groupID: installBGroupQQ, qq: ats[1].target);
          if (envyList.length <= 0) {
            replyMsg(recvMsg, buildPlainMsgItem('${queryMember.nickname}从不羡慕他人'));
          } else {
            replyMsg(recvMsg, buildPlainMsgItem('${queryMember.nickname}已经羡慕了${envyStore['count']}次'));
          }
          return;
        }
      }

      var content = '';
      contents.forEach((element) {
        content += element.text;
      });
      if (!content.contains(KEY_WORD)) return;

      final senderQQ = recvMsg.sender.id;
      final envyList = await DataManager().fetchLeanStorage(classes: 'envy', query: {'qq': senderQQ});
      if (envyList.length <= 0) {
        DataManager().createLeanStorage(classes: 'envy', data: {'qq': recvMsg.sender.id, 'count': 1});
      } else {
        final envyStore = envyList[0];
        DataManager().incrementLeanStorage(classes: 'envy', objectID: envyStore['objectId']);
      }
    }
  }
}
