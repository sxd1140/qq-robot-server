import 'package:qq_robot_server/plugin/plugin.dart';

import '/Constant.dart';
import '/model/message.dart';
import '/slib.dart';
import '/util.dart';

class PluginSwitch extends Plugin {
  @override
  onRecvMsg(Map msg) async {
    super.onRecvMsg(msg);

    late final recvMsg;
    if (msg.isGroupMessage) {
      recvMsg = RecvGroupMessage.fromJson(msg);
      //只关注@自己的群消息
      var at = false;
      for (var item in recvMsg.messageChain) {
        if (item is MsgItemAt) {
          if (item.target == robotQQ) {
            at = true;
            break;
          }
        }
      }
      if (!at) return;
    } else if (msg.isFriendMessage || msg.isTempMessage) {
      recvMsg = RecvFriendMessage.fromJson(msg);
    } else
      return;

    final item = recvMsg.messageChain.firstWhere((element) => element is MsgItemPlain);
    String queryText = item.text.trim();
    if (!queryText.startsWith('switch')) return;
    queryText = queryText.replaceFirst('switch', '').trim();

    final url = 'https://switch.jumpvg.com/switch/gameDlc/list';
    final result = await get(url, queryParameters: {'title': queryText, 'offset': 0, 'limit': 1});
    if ((result['result']['code'] != 0) || (result['data']['games'].length < 1)) {
      _returnNotFound(recvMsg);
      return;
    }

    final game = result['data']['games'][0];
    final name = game['titleZh'];
    final recommendLabel = game['recommendLabel'] ?? '';
    final image = game['icon'];
    final price = game['price'];
    final country = game['country'];

    final text = '\n$name $recommendLabel\n$country $price';
    replyMsg(recvMsg, [
      buildImageMsgItem(url: image),
      buildPlainMsgItem(text),
    ]);
  }
}

_returnNotFound(Message recvMsg) {
  replyMsg(recvMsg, buildPlainMsgItem('找不到这个屌游戏啊'));
}
