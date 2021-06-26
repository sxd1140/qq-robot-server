import 'package:qq_robot_server/model/message.dart';

import 'envy.dart';
import 'steam.dart';
import 'switch.dart';

final List<Plugin> PluginList = [
  PluginSteam(),
  PluginSwitch(),
  PluginEnvy(),
];

class Plugin {
  onInit() {}

  onRecvMsg(Message msg) {}
}
