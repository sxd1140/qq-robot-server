import 'dart:convert';

import 'package:qq_robot_server/slib.dart';

class DataManager {
  final LeanAppID = 'wBo8p3c26p5JHxx54QOKdGyi-9Nh9j0Va';
  final LeanAppKey = '4qv8FMtwwmLmBciHPBClHMYo';
  final LeanRestAPIDomain = 'https://wbo8p3c2.lc-cn-e1-shared.com';
  late final LeanAuthHeader;

  static final DataManager _singleton = DataManager._internal();

  factory DataManager() {
    return _singleton;
  }

  DataManager._internal();

  bool _inited = false;

  init() async {
    if (_inited) return;
    _inited = true;
    LeanAuthHeader = {'X-LC-Id': LeanAppID, 'X-LC-Key': LeanAppKey, 'Content-Type': 'application/json'};
  }

  fetchLeanStorage({required String classes, JSON? query}) async {
    JSON? params;
    if (query != null) {
      params = {'where': jsonEncode(query)};
    }
    final result = await get('$LeanRestAPIDomain/1.1/classes/$classes', queryParameters: params, headers: LeanAuthHeader);
    return result['results'];
  }

  void createLeanStorage({required String classes, required data}) async {
    final result = await post('$LeanRestAPIDomain/1.1/classes/$classes', headers: LeanAuthHeader, body: data);
    return result;
  }

  ///累加
  void incrementLeanStorage({required String classes, required String objectID, int amount = 1}) async {
    final JSON body = {
      'count': {'__op': 'Increment', 'amount': amount}
    };
    final result = await put('$LeanRestAPIDomain/1.1/classes/$classes/$objectID', body: body, headers: LeanAuthHeader);
    return result;
  }
}
