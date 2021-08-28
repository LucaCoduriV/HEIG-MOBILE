import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/todos_provider.dart';
import 'package:heig_front/models/todo.dart';

class TaskInfo extends StatefulWidget {
  final Todo todo;
  const TaskInfo({Key? key, required this.todo}) : super(key: key);

  @override
  _TaskInfoState createState() => _TaskInfoState();
}

class _TaskInfoState extends State<TaskInfo> {
  @override
  Widget build(BuildContext context) {
    Todo todo = widget.todo;
    return Dismissible(
      onDismissed: (direction) {
        GetIt.I<TodosProvider>().removeTodo(todo.id);
      },
      confirmDismiss: (direction) async {
        const duration = Duration(seconds: 2);
        bool result = true;
        final snackBar = SnackBar(
          duration: duration,
          content: const Text('Tâche supprimé'),
          action: SnackBarAction(
            label: 'Annulé',
            onPressed: () {
              result = false;
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        await Future.delayed(duration);

        return result;
      },
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 80),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: !todo.completed ? Color(0xFFFEF5F6) : Color(0xFFF4FEF8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    todo.title,
                    style: TextStyle(
                      color: !todo.completed ? Colors.black : Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      decoration: todo.completed
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    height: 30,
                    child: Checkbox(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      value: todo.completed,
                      onChanged: (change) {
                        GetIt.I<TodosProvider>().completeTodo(todo.id, change!);
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    todo.description,
                    style: TextStyle(
                      color: !todo.completed ? Colors.black : Colors.grey,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
