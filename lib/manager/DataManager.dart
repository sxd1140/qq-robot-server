class DataManager {
  static final DataManager _singleton = DataManager._internal();

  factory DataManager() {
    return _singleton;
  }

  DataManager._internal();

  bool _inited = false;

  init() async {
    if (_inited) return;
    _inited = true;
  }
}
