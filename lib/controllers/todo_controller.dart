import 'package:heig_front/models/todo.dart';

class TodoController {
  List<Todo> _todos = [];

  void addTodo(
      String title, String description, bool completed, DateTime date) {
    _todos.add(Todo(title, description, completed, date));
  }

  void removeTodo(int id) {
    _todos.removeAt(id);
  }

  void updateTodo(
      int id, String title, String description, bool completed, DateTime date) {
    _todos[id] = Todo(title, description, completed, date);
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
  }
}
