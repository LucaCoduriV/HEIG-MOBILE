import 'package:hive_flutter/hive_flutter.dart';

class IdGenerator {
  static const BOX_NAME = 'ID_GENERATOR';
  final _box = Hive.box(BOX_NAME);

  static Future<void> initialize() async {
    await Hive.openBox<dynamic>(BOX_NAME);
  }

  late int _lastId;
  final String name;

  IdGenerator(this.name) {
    _lastId = _box.get(name, defaultValue: -1);
  }

  int nextId() {
    _lastId++;
    _box.put(name, _lastId);
    return _lastId;
  }

  void reset() {
    _lastId = 0;
    _box.put(name, _lastId);
  }
}
