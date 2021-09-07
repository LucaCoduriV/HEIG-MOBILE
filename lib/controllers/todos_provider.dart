import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:heig_front/models/todo.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

class TodosProvider extends ChangeNotifier {
  late Map<String, Todo> _todos;
  var box = Hive.box('heig');

  TodosProvider() {
    _todos = Map.from(box.get('todos', defaultValue: Map<String, Todo>()));
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

    AwesomeNotifications().createNotification(
      schedule: DateTime.now().isAfter(date.subtract(Duration(days: 1)))
          ? null
          : NotificationCalendar.fromDate(
              date: date.subtract(Duration(days: 1))),
      content: NotificationContent(
        id: 10,
        channelKey: 'todos_channel',
        title: 'Tâche: $title',
        body: description,
      ),
    );

    saveTodos();
  }

  void removeTodo(String id) {
    _todos.remove(id);

    saveTodos();
  }

  void updateTodo(String id, String title, String description, bool completed,
      DateTime date) {
    _todos[id] = Todo(id, title, description, completed, date);

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
    saveTodos();
  }

  void setTodos(Map<String, Todo> todos) {
    _todos = todos;

    saveTodos();
  }
}
