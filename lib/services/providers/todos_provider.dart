import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/todo.dart';
import '../notifications_manager.dart';

/// Cette classe permet de distribuer et mettre à jours les données concernant les tâches.
class TodosProvider extends ChangeNotifier {
  late Map<int, Todo> _todos;
  int _id = 0;
  var box = Hive.box('heig');

  TodosProvider() {
    _id = box.get('todos_id', defaultValue: 0);
    _todos = Map.from(box.get('todos', defaultValue: <int, Todo>{}));
  }

  void saveTodos() {
    box.put('todos', _todos);
    notifyListeners();
  }

  Future<void> addTodo(String title, String description, DateTime date,
      {required bool completed}) async {
    final int notifId = await GetIt.I
        .get<NotificationsManager>()
        .registerNotificationTodo(title, description, date, _id);
    _todos[_id] = Todo(_id, title, description, date, completed: completed);
    _todos[_id]!.notificationId = notifId;
    _id++;
    box.put('todos_id', _id);
    saveTodos();
  }

  void removeTodo(int id) {
    _todos.remove(id);

    saveTodos();
  }

  void updateTodo(int id, String title, String description, DateTime date,
      {required bool completed}) {
    _todos[id] = Todo(id, title, description, date, completed: completed);

    saveTodos();
  }

  void completeTodo(int id, {required bool completed}) {
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

  Map<int, Todo> getTodos() {
    return _todos;
  }

  void clearTodos() {
    _todos.clear();
    saveTodos();
  }

  void setTodos(Map<int, Todo> todos) {
    _todos = todos;

    saveTodos();
  }
}
