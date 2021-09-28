import 'package:hive_flutter/hive_flutter.dart';

class IdGenerator {
  late int _lastId;
  final String name;
  static final _box = Hive.box('idGenerator');

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
