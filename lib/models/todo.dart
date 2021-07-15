import 'package:hive_flutter/adapters.dart';

part 'todo.g.dart';

@HiveType(typeId: 6)
class Todo {
  @HiveField(0)
  late int _id;
  @HiveField(1)
  late String _title;
  @HiveField(2)
  late String _description;
  @HiveField(3)
  late bool _completed;
  @HiveField(4)
  late DateTime? _date;

  Todo(
      int id, String title, String description, bool completed, DateTime date) {
    _id = id;
    _title = title;
    _description = description;
    _completed = completed;
    _date = date;
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      int.parse(json["id"]),
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
