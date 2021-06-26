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
  onRecvMsg(Message recvMsg) async {
    super.onRecvMsg(recvMsg);
    if (recvMsg is! RecvGroupMessage) return;
    if ((recvMsg.sender as GroupMsgSender).group['id'] != installBGroupQQ) return;

    final contents = recvMsg.allText;
    if (contents.length <= 0) return;

    // /羡慕 @要查询的人
    if (contents.startsWith('/$KEY_WORD')) {
      final ats = recvMsg.messageChain.whereType<MsgItemAt>().toList();
      if (ats.length <= 0) {
        replyMsg(recvMsg, '请手动@一个人');
        return;
      }
      final envyList = await DataManager().fetchLeanStorage(classes: 'envy', query: {'qq': ats[0].target});
      final queryMember = await QQManager().fetchGroupMemberProfile(groupID: installBGroupQQ, qq: ats[0].target);
      if (envyList.length <= 0) {
        replyMsg(recvMsg, '${queryMember.nickname}从不羡慕他人');
      } else {
        final envyStore = envyList[0];
        replyMsg(recvMsg, '${queryMember.nickname}已经羡慕了${envyStore['count']}次');
      }
    } else {
      if (!contents.contains(KEY_WORD)) return;

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
