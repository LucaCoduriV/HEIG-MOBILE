import 'package:hive_flutter/adapters.dart';

part 'todo.g.dart';

@HiveType(typeId: 7)
class Todo {
  @HiveField(0)
  late String _id;
  @HiveField(1)
  late String _title;
  @HiveField(2)
  late String _description;
  @HiveField(3)
  late bool _completed;
  @HiveField(4)
  late DateTime _date;

  String get id => _id;
  String get title => _title;
  String get description => _description;
  bool get completed => _completed;
  DateTime get date => _date;

  set completed(bool completed) => _completed = completed;

  Todo(String id, String title, String description, bool completed,
      DateTime date) {
    _id = id;
    _title = title;
    _description = description;
    _completed = completed;
    _date = date;
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      json["id"],
      json["title"],
      json["description"],
      json["completed"],
      DateTime.parse(json["date"]),
    );
  }

  @override
  String toString() {
    return "$_id $_title $_description $_completed $_date";
  }
}
