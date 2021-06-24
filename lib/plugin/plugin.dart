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

  onRecvMsg(Map msg) {}
}
