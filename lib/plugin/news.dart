import 'dart:convert';

import 'package:cron/cron.dart';
import 'package:qq_robot_server/Constant.dart';
import 'package:qq_robot_server/manager/QQManager.dart';

import '../slib.dart';
import 'plugin.dart';

class PluginNews extends Plugin {
  @override
  onInit() async {
    super.onInit();

    final cron = Cron();
    cron.schedule(Schedule.parse('0 0 10,20 * * *'), onNewsTimerHandler);
  }

  onNewsTimerHandler() async {
    var result = await get('https://top.baidu.com/board?tab=realtime', parseJSON: false);
    result = result.toString();
    const startLabel = '<!--s-data:{"data":';
    final posStart = result.indexOf(startLabel);
    final posEnd = result.indexOf('<div class="bg-wrapper">', posStart);
    String strData = result.substring(posStart + startLabel.length, posEnd - 4);
    //json格式居然是错的 多一个}
    strData = strData.replaceFirstMapped(RegExp(r'("logid":"\d+")}'), (Match match) {
      return match.group(1)!;
    });
    var ret = '';
    final data = json.decode(strData);
    data['cards'][0]['content'].take(10).forEach((ele) {
      ret += '${ele['desc']}\n';
    });
    QQManager().sendGroupMsg(target: installBGroupQQ, message: ret);
  }
}
