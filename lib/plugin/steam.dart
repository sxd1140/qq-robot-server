import 'package:html/parser.dart';
import 'package:puppeteer/puppeteer.dart';
import 'package:qq_robot_server/plugin/plugin.dart';

import '/Constant.dart';
import '/model/message.dart';
import '/slib.dart';
import '/util.dart';

class PluginSteam extends Plugin {
  String KEY_WORD = 'steam';

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

    final url = 'https://store.steampowered.com/search';
    final result = await get(url, queryParameters: {'term': contents}, parseJSON: false);
    final domHTML = parse(result.toString());
    final domFirst = domHTML.querySelector('div#search_resultsRows>a.search_result_row');
    if (domFirst == null) {
      _returnNotFound(recvMsg);
      return;
    } else {
      replyMsg(recvMsg, '等老子给你找下, 莫急.');
      final appID = domFirst.attributes['data-ds-appid'];
      final appDetail = (await get('https://store.steampowered.com/api/appdetails?appids=$appID&l=schinese&cc=cn'))[appID]['data'];
      final name = appDetail['name'];
      final shortDesc = appDetail['short_description'];
      final image = appDetail['header_image'];
      final isFree = appDetail['package_groups'].length == 0; //appDetail['is_free'];
      var text = '\n$name\n$shortDesc\n';

      final price = [];
      if (isFree) {
        text += '免费';
      } else {
        final subs = appDetail['package_groups'][0]['subs'];
        for (int i = 0; i < subs.length; i++) {
          price.add(subs[i]['option_text']);
        }

        final browser = await puppeteer.launch(args: [
          '--disable-application-cache',
          '-–disk-cache-size=1',
          '--start-maximized',
          '--ignore-certificate-errors',
          '--disable-blink-features=AutomationControlled',
          '--disable-gpu',
          '--no-sandbox',
          '--no-zygote',
          '--disable-setuid-sandbox',
          '--disable-accelerated-2d-canvas',
          '--disable-dev-shm-usage',
          "--proxy-server='direct://'",
          '--proxy-bypass-list=*',
          '--disable-infobars',
          '--window-position=0,0',
          '--ignore-certifcate-errors-spki-list',
        ], defaultViewport: DeviceViewport(width: 1920, height: 1080), ignoreHttpsErrors: true, headless: false /*我放弃了显示出界面才正常*/);
        final steamDBPage = await browser.newPage();
        steamDBPage.setUserAgent('Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3312.0 Safari/537.36');
        await steamDBPage.goto('https://steamdb.info/app/$appID', wait: Until.networkIdle);
        await steamDBPage.waitForSelector('div.app-row table.table>tbody>tr');
        final steamDBAppID = await steamDBPage.$eval('div.app-row table.table>tbody>tr>td:nth-child(2)', 'node => node.innerText');
        if (steamDBAppID != appID) {
          _returnNotFound(recvMsg);
          browser.close();
          return;
        }
        final lowestPrice = await steamDBPage.$$eval('table.table>tbody>tr>td[data-cc="cn"]~td', 'tds => tds[3].innerText');
        text += '${price.join('\n')}\n史低$lowestPrice';
        browser.close();
      }

      replyMsg(recvMsg, [
        buildImageMsgItem(url: image),
        buildPlainMsgItem(text),
      ]);
    }
  }
}

_returnNotFound(Message recvMsg) {
  replyMsg(recvMsg, '找不到这个屌游戏啊');
}
