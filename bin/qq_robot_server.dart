import 'package:args/args.dart';
import 'package:qq_robot_server/Constant.dart';
import 'package:qq_robot_server/main.dart' as entry;

void main(List<String> arguments) {
  final parser = ArgParser()..addOption('serverDomain');

  ArgResults argResults = parser.parse(arguments);
  final url = argResults['serverDomain'];
  if (url != null) {
    serverDomain = url;
  }

  entry.main(arguments);
}
