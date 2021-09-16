import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controllers/todos_provider.dart';

class TodosDialog extends StatefulWidget {
  const TodosDialog({Key? key}) : super(key: key);

  @override
  _TodosDialogState createState() => _TodosDialogState();
}

class _TodosDialogState extends State<TodosDialog> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      titlePadding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
      contentPadding: const EdgeInsets.all(20),
      backgroundColor: Colors.white,
      title: const Text('Ajouter une tache'),
      children: [
        Form(
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(hintText: 'Titre'),
                controller: title,
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: 'Description'),
                controller: description,
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      '${date.day.toString()}/${date.month.toString()}/${date.year.toString()}'),
                  OutlinedButton(
                      onPressed: () async {
                        final DateTime? _date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2050));
                        setState(() {
                          date = _date ?? DateTime.now();
                        });
                      },
                      child: const Text('Choisir une date')),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        GetIt.I<TodosProvider>().addTodo(
                            title.text, description.text, date,
                            completed: false);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Valider')),
                  OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Annuler')),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
