import 'package:args/args.dart';
import 'package:qq_robot_server/Constant.dart';
import 'package:qq_robot_server/main.dart' as entry;

void main(List<String> arguments) {
  final parser = ArgParser()..addOption('serverDomain');

  ArgResults argResults = parser.parse(arguments);
  serverDomain = argResults['serverDomain'];

  entry.main(arguments);
}
