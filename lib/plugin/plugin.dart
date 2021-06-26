import 'package:qq_robot_server/model/message.dart';
import 'package:qq_robot_server/plugin/help.dart';

import 'envy.dart';
import 'steam.dart';
import 'switch.dart';

final List<Plugin> PluginList = [
  PluginHelp(),
  PluginSteam(),
  PluginSwitch(),
  PluginEnvy(),
];

class Plugin {
  onInit() {}

  onRecvMsg(Message recvMsg) {}
}
