import 'package:flutter/cupertino.dart';
import 'package:heig_front/models/todo.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TodosProvider extends ChangeNotifier {
  late List<Todo> _todos;
  var box = Hive.box('heig');

  TodosProvider() {
    _todos = box.get('todos', defaultValue: <Todo>[]).cast<Todo>();
  }

  void saveTodos() {
    box.put('todos', _todos);
    notifyListeners();
  }

  void addTodo(int id, String title, String description, bool completed,
      DateTime? date) {
    _todos.add(Todo(id, title, description, completed, date));
    saveTodos();
  }

  void removeTodo(int id) {
    _todos.removeAt(id);
    saveTodos();
  }

  void updateTodo(
      int id, String title, String description, bool completed, DateTime date) {
    _todos[id] = Todo(id, title, description, completed, date);
    saveTodos();
  }

  void completeTodo(int index, bool completed) {
    _todos[index].completed = completed;
  }

  Todo getTodo(int id) {
    return _todos[id];
  }

  List<Todo> getTodos() {
    return _todos;
  }

  void clearTodos() {
    _todos.clear();
  }

  void setTodos(List<Todo> todos) {
    _todos = todos;
    saveTodos();
  }
}
