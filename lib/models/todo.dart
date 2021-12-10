import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:heig_front/utils/notifiable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:uuid/uuid.dart';

part 'todo.g.dart';

@HiveType(typeId: 7)
class Todo with CanNotify {
  @HiveField(0)
  late String _id;
  @HiveField(1)
  late String _title;
  @HiveField(2)
  late String _description;
  @HiveField(3)
  late bool completed;
  @HiveField(4)
  late DateTime _date;

  final uuid = const Uuid();

  String get id => _id;
  String get title => _title;
  String get description => _description;
  DateTime get date => _date;

  Todo(
    String title,
    String description,
    DateTime date, {
    required this.completed,
    String id = '',
  })  : _title = title,
        _description = description,
        _date = date {
    if (id == '') {
      _id = uuid.v4();
    }

    final NotificationCalendar? _calendar =
        DateTime.now().isAfter(date.subtract(const Duration(days: 1)))
            ? null
            : NotificationCalendar.fromDate(
                date: date.subtract(const Duration(days: 1)),
              );

    initCanNotifyMixin(
        _calendar,
        NotificationContent(
          id: 0,
          channelKey: 'todos_channel',
          title: 'Tâche: $title',
          body: description,
          payload: {
            'page': 'todo',
            'id': id,
          },
        ));

    scheduleNotification();
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
        json['title'], json['description'], DateTime.parse(json['date']),
        completed: json['completed'], id: json['id']);
  }

  @override
  String toString() {
    return '$_id $_title $_description $completed $_date';
  }
}
