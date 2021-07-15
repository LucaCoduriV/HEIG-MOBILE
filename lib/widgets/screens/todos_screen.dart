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
          DateTime? date = todos[index].date;
          Todo todo = todos[index];
          return Dismissible(
            background: Container(color: Colors.red),
            key: Key(todo.title),
            onDismissed: (direction) {
              GetIt.I<TodosProvider>().removeTodo(index);
            },
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          todo.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                            "${date?.day.toString()}/${date?.month.toString()}/${date?.year.toString()}"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(todo.description),
                          ],
                        ),
                        Checkbox(
                          value: todo.completed,
                          onChanged: (change) => GetIt.I<TodosProvider>()
                              .completeTodo(index, change!),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
