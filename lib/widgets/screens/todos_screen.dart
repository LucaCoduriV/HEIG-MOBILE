import 'package:flutter/material.dart';
import 'package:heig_front/controllers/todos_provider.dart';
import 'package:heig_front/models/todo.dart';
import 'package:heig_front/widgets/task_info.dart';
import 'package:provider/provider.dart';

class TodosScreen extends StatelessWidget {
  const TodosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Todo> todos = context.watch<TodosProvider>().getTodos();
    return Container(
      color: Colors.white,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: todos.length,
        itemBuilder: (context, index) {
          Todo todo = todos[index];
          return TaskInfo(todo: todo, index: index);
        },
      ),
    );
  }
}
