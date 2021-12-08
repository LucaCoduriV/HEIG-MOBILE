import 'package:hive_flutter/hive_flutter.dart';

import 'constants.dart';

class IdGenerator {
  static late final Box<dynamic> _box;
  final int _min;
  final int _max;

  static Future<void> initialize() async {
    _box = await Hive.openBox<dynamic>(BOX_ID_GENERATOR);
  }

  late int _lastId;
  final String name;

  IdGenerator(this.name, {int min = 0, int max = 9999999})
      : _min = min,
        _max = max {
    _lastId = _box.get(name, defaultValue: _min);
  }

  int nextId() {
    _lastId++;
    if (_lastId > _max) {
      _lastId = _min;
    }
    _box.put(name, _lastId);
    return _lastId;
  }

  void reset() {
    _lastId = _min;
    _box.put(name, _lastId);
  }
}
