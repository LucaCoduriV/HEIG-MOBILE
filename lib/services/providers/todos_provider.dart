import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/todo.dart';

/// Cette classe permet de distribuer et mettre à jours les données concernant les tâches.
class TodosProvider extends ChangeNotifier {
  late Map<String, Todo> _todos;
  var box = Hive.box('heig');

  TodosProvider() {
    _todos = Map.from(box.get('todos', defaultValue: <int, Todo>{}));
  }

  Future<void> addTodo(
    String title,
    String description,
    DateTime date, {
    required bool completed,
  }) async {
    final todo = Todo(title, description, date, completed: completed);
    _todos[todo.id] = todo;

    _saveTodos();
  }

  void clearTodos() {
    _todos.clear();
    _saveTodos();
  }

  void completeTodo(String id, {required bool completed}) {
    _todos[id]?.completed = completed;
    notifyListeners();
    _saveTodos();
  }

  List<Todo> getDailyTodos(DateTime date) {
    return _todos.values
        .where((element) =>
            date.day == element.date.day &&
            date.month == element.date.month &&
            date.year == element.date.year)
        .toList();
  }

  Todo? getTodo(String id) {
    return _todos[id];
  }

  Map<String, Todo> get todos => _todos;

  /// Permet d'avoir toutes les taches pour une semaine
  List<Todo> getTodosByWeek(DateTime firstDayOfWeek) {
    return _todos.values
        .where((element) =>
            element.date.difference(firstDayOfWeek).inDays <= 6 &&
            element.date.difference(firstDayOfWeek).inDays >= 0)
        .toList();
  }

  void removeTodo(String id) {
    _todos.remove(id);

    _saveTodos();
  }

  void setTodos(Map<String, Todo> todos) {
    _todos = todos;

    _saveTodos();
  }

  void updateTodo(String id, String title, String description, DateTime date,
      {required bool completed}) {
    final todo = Todo(title, description, date, completed: completed);
    _todos[id] = todo;

    _saveTodos();
  }

  void _saveTodos() {
    box.put('todos', _todos);
    notifyListeners();
  }
}
