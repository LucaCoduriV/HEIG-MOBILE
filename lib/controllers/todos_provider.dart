import 'package:flutter/cupertino.dart';
import 'package:heig_front/models/todo.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:uuid/uuid.dart';

class TodosProvider extends ChangeNotifier {
  late Map<String, Todo> _todos;
  var box = Hive.box('heig');

  TodosProvider() {
    FlutterLocalNotificationsPlugin().cancelAll();
    _todos = Map.from(box.get('todos', defaultValue: Map<String, Todo>()));
    setNotificationForAll();
  }

  void setNotificationForAll() {
    // for (int i = 0; i < _todos.length; i++) {
    //   Todo todo = _todos[i];

    //   scheduleNotifaction('0', todo.date, todo.title, todo.description);
    // }
  }

  void saveTodos() {
    box.put('todos', _todos);
    notifyListeners();
  }

  void addTodo(
      String title, String description, bool completed, DateTime date) {
    var uuid = Uuid();
    String id = uuid.v4();
    _todos[id] = Todo(id, title, description, completed, date);
    saveTodos();
    scheduleNotifaction(id, date, title, description);
  }

  void removeTodo(String id) {
    _todos.remove(id);
    //FlutterLocalNotificationsPlugin().cancel(id);

    saveTodos();
  }

  void updateTodo(String id, String title, String description, bool completed,
      DateTime date) {
    _todos[id] = Todo(id, title, description, completed, date);
    //FlutterLocalNotificationsPlugin().cancel(id);
    //scheduleNotifaction(id, date, title, description);

    saveTodos();
  }

  void completeTodo(String id, bool completed) {
    _todos[id]?.completed = completed;
    notifyListeners();
    saveTodos();
  }

  Todo? getTodo(String id) {
    return _todos[id];
  }

  /// Permet d'avoir toutes les taches pour une semaine
  List<Todo> getTodosByWeek(DateTime firstDayOfWeek) {
    return _todos.values
        .where((element) =>
            element.date.difference(firstDayOfWeek).inDays <= 6 &&
            element.date.difference(firstDayOfWeek).inDays >= 0)
        .toList();
  }

  List<Todo> getDailyTodos(DateTime date) {
    return _todos.values
        .where((element) =>
            date.day == element.date.day &&
            date.month == element.date.month &&
            date.year == element.date.year)
        .toList();
  }

  Map<String, Todo> getTodos() {
    return _todos;
  }

  void clearTodos() {
    _todos.clear();
    FlutterLocalNotificationsPlugin().cancelAll();
    saveTodos();
  }

  void setTodos(Map<String, Todo> todos) {
    _todos = todos;
    FlutterLocalNotificationsPlugin().cancelAll();

    saveTodos();
  }

  void scheduleNotifaction(
      String id, DateTime date, String title, String description) {
    // if (date.isAfter(DateTime.now())) {
    //   var notifPlugin = FlutterLocalNotificationsPlugin();
    //   notifPlugin.zonedSchedule(
    //     0,
    //     "HEIG",
    //     "$title - $description",
    //     tz.TZDateTime.from(date.add(Duration(seconds: 30)), tz.local),
    //     const NotificationDetails(
    //         android: AndroidNotificationDetails(
    //             'HEIG', 'todos', 'Notifications for todos')),
    //     uiLocalNotificationDateInterpretation:
    //         UILocalNotificationDateInterpretation.absoluteTime,
    //     androidAllowWhileIdle: false,
    //   );
    // }
  }
}
