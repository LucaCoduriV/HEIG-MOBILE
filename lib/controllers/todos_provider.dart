import 'package:flutter/cupertino.dart';
import 'package:heig_front/models/todo.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class TodosProvider extends ChangeNotifier {
  late List<Todo> _todos;
  var box = Hive.box('heig');

  TodosProvider() {
    FlutterLocalNotificationsPlugin().cancelAll();
    _todos = box.get('todos', defaultValue: <Todo>[]).cast<Todo>();
    setNotificationForAll();
  }

  void setNotificationForAll() {
    for (int i = 0; i < _todos.length; i++) {
      Todo todo = _todos[i];

      if (todo.date != null)
        scheduleNotifaction(i, todo.date!, todo.title, todo.description);
    }
  }

  void saveTodos() {
    box.put('todos', _todos);
    notifyListeners();
  }

  void addTodo(int id, String title, String description, bool completed,
      DateTime? date) {
    _todos.add(Todo(id, title, description, completed, date));
    saveTodos();
    if (date != null) scheduleNotifaction(id, date, title, description);
  }

  void removeTodo(int index) {
    _todos.removeAt(index);
    FlutterLocalNotificationsPlugin().cancel(index);

    saveTodos();
  }

  void updateTodo(
      int id, String title, String description, bool completed, DateTime date) {
    _todos[id] = Todo(id, title, description, completed, date);
    FlutterLocalNotificationsPlugin().cancel(id);
    scheduleNotifaction(id, date, title, description);

    saveTodos();
  }

  void completeTodo(int index, bool completed) {
    _todos[index].completed = completed;
    notifyListeners();
    saveTodos();
  }

  Todo getTodo(int id) {
    return _todos[id];
  }

  List<Todo> getTodos() {
    return _todos;
  }

  void clearTodos() {
    _todos.clear();
    FlutterLocalNotificationsPlugin().cancelAll();
    saveTodos();
  }

  void setTodos(List<Todo> todos) {
    _todos = todos;
    FlutterLocalNotificationsPlugin().cancelAll();

    saveTodos();
  }

  void scheduleNotifaction(
      int id, DateTime date, String title, String description) {
    if (date.isAfter(DateTime.now())) {
      var notifPlugin = FlutterLocalNotificationsPlugin();
      notifPlugin.zonedSchedule(
        0,
        "HEIG",
        "$title - $description",
        tz.TZDateTime.from(date.add(Duration(seconds: 30)), tz.local),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'HEIG', 'todos', 'Notifications for todos')),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: false,
      );
    }
  }
}
