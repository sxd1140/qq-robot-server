import 'package:qq_robot_server/model/message.dart';
import 'package:qq_robot_server/plugin/plugin.dart';
import 'package:qq_robot_server/util.dart';

class PluginHelp extends Plugin {
  @override
  onRecvMsg(Message recvMsg) {
    super.onRecvMsg(recvMsg);

    String contents = recvMsg.allText;
    if (contents.length <= 0) return;

    if (!contents.startsWith('/help')) return;
    replyMsg(
        recvMsg,
        [
          '/steam 游戏   (残废中)',
          '/switch 游戏',
          '/羡慕 @人',
        ].join('\n'));
  }
}
