import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/todos_provider.dart';
import 'package:heig_front/models/todo.dart';
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
          return Card(
            child: Column(
              children: [
                Text(todos[index].title),
                Row(
                  children: [
                    Text(todos[index].description),
                    Text(todos[index].date.toString()),
                    Checkbox(
                      value: todos[index].completed,
                      onChanged: (change) =>
                          GetIt.I<TodosProvider>().completeTodo(index, change!),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
