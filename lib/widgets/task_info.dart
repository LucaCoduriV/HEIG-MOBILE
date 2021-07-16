import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/todos_provider.dart';
import 'package:heig_front/models/todo.dart';

class TaskInfo extends StatefulWidget {
  final Todo todo;
  final int index;
  const TaskInfo({Key? key, required this.todo, required this.index})
      : super(key: key);

  @override
  _TaskInfoState createState() => _TaskInfoState();
}

class _TaskInfoState extends State<TaskInfo> {
  @override
  Widget build(BuildContext context) {
    Todo todo = widget.todo;
    int index = widget.index;
    DateTime? date = todo.date;
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
                      decoration: todo.completed
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
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
                    onChanged: (change) =>
                        GetIt.I<TodosProvider>().completeTodo(index, change!),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
