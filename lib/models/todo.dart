import 'package:hive_flutter/adapters.dart';

part 'todo.g.dart';

@HiveType(typeId: 7)
class Todo {
  @HiveField(0)
  late int _id;
  @HiveField(1)
  late String _title;
  @HiveField(2)
  late String _description;
  @HiveField(3)
  late bool completed;
  @HiveField(4)
  late DateTime _date;
  @HiveField(5)
  late int notificationId;

  int get id => _id;
  String get title => _title;
  String get description => _description;
  DateTime get date => _date;

  Todo(
      int id, String title, String description, bool completed, DateTime date) {
    _id = id;
    _title = title;
    _description = description;
    completed = completed;
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
    return "$_id $_title $_description $completed $_date";
  }
}
