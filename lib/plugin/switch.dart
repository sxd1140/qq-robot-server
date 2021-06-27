import 'package:qq_robot_server/plugin/plugin.dart';

import '/model/message.dart';
import '/slib.dart';
import '/util.dart';

class PluginSwitch extends Plugin {
  String KEY_WORD = 'switch';

  @override
  onRecvMsg(Message recvMsg) async {
    super.onRecvMsg(recvMsg);

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

    final text = [
      '',
      '$name $recommendLabel',
      if (game['chinese_all'] == 1) '全区中文' else if (game['chineseVer'] == 1) '有中文' else null,
      if (country != null && price != null) '${country ?? ''} ${price ?? ''}',
    ].join('\n');
    replyMsg(recvMsg, [
      buildImageMsgItem(url: image),
      buildPlainMsgItem(text),
    ]);
  }
}

_returnNotFound(Message recvMsg) {
  replyMsg(recvMsg, '找不到这个屌游戏啊');
}
