import 'package:puppeteer/plugins/stealth.dart';
import 'package:puppeteer/puppeteer.dart';
import 'package:qq_robot_server/manager/QQManager.dart';

void main(List<String> arguments) {
  QQManager().init();
  puppeteer.plugins.add(StealthPlugin());
}
