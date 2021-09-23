import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/todo.dart';
import '../services/theme_data.dart' as theme;
import '../services/providers/todos_provider.dart';

/// Affiche les informations d'une tâche.
class TodoInfo extends StatefulWidget {
  final Todo todo;
  const TodoInfo({Key? key, required this.todo}) : super(key: key);

  @override
  _TodoInfoState createState() => _TodoInfoState();
}

class _TodoInfoState extends State<TodoInfo> {
  @override
  Widget build(BuildContext context) {
    final Todo todo = widget.todo;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Dismissible(
        key: Key(todo.id.toString()),
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
              label: 'Annuler',
              onPressed: () {
                result = false;
              },
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          // ignore: inference_failure_on_instance_creation
          await Future.delayed(duration);

          return result;
        },
        direction: DismissDirection.endToStart,
        background: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 80),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: !todo.completed
                  ? theme.COLOR_PRIMARY_LIGHT_LIGHT
                  : theme.COLOR_GREEN_LIGHT_LIGHT,
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
                        color:
                            !todo.completed ? Colors.black : theme.COLOR_GREY,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        decoration: todo.completed
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      height: 30,
                      child: Checkbox(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        value: todo.completed,
                        onChanged: (change) {
                          GetIt.I<TodosProvider>()
                              .completeTodo(todo.id, completed: change!);
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
                        color:
                            !todo.completed ? Colors.black : theme.COLOR_GREY,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
