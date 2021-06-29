import 'package:qq_robot_server/model/message.dart';

import 'envy.dart';
import 'help.dart';
import 'news.dart';
import 'steam.dart';
import 'switch.dart';

final List<Plugin> PluginList = [
  PluginHelp(),
  PluginSteam(),
  PluginSwitch(),
  PluginEnvy(),
  PluginNews(),
];

class Plugin {
  onInit() {}

  onRecvMsg(Message recvMsg) {}
}
