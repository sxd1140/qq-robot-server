import 'package:qq_robot_server/plugin/plugin.dart';

import '/Constant.dart';
import '/model/message.dart';
import '/slib.dart';
import '/util.dart';

class PluginSwitch extends Plugin {
  String KEY_WORD = 'switch';

  @override
  onRecvMsg(Map msg) async {
    super.onRecvMsg(msg);
    late final recvMsg;
    if (msg.isGroupMessage) {
      recvMsg = RecvGroupMessage.fromJson(msg);
    } else if (msg.isFriendMessage || msg.isTempMessage) {
      recvMsg = RecvFriendMessage.fromJson(msg);
    } else {
      return;
    }

    String contents = recvMsg.allText;
    if (contents.length <= 0) return;

    if (!contents.startsWith('/$KEY_WORD')) return;

    contents = contents.replaceFirst('/$KEY_WORD', '').trim();

    final url = 'https://switch.jumpvg.com/switch/gameDlc/list';
    final result = await get(url, queryParameters: {'title': contents, 'offset': 0, 'limit': 1});
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
  replyMsg(recvMsg, '找不到这个屌游戏啊');
}
