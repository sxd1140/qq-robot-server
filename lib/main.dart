import 'package:puppeteer/plugins/stealth.dart';
import 'package:puppeteer/puppeteer.dart';
import 'package:qq_robot_server/manager/DataManager.dart';
import 'package:qq_robot_server/manager/QQManager.dart';

import 'httpServer.dart' as httpServer;

void main(List<String> arguments) {
  puppeteer.plugins.add(StealthPlugin());
  DataManager().init();
  QQManager().init();
  httpServer.init();
}
