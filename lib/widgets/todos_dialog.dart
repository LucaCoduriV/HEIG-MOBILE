import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/todos_provider.dart';

class TodosDialog extends StatelessWidget {
  const TodosDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.all(10),
      backgroundColor: Colors.white,
      title: Text('Ajouter une tache'),
      children: [
        Form(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(hintText: "Titre"),
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Description"),
              ),
              Row(
                children: [
                  Text("date"),
                  OutlinedButton(
                      onPressed: () => showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2050)),
                      child: Text("Select date")),
                ],
              ),
              Row(
                children: [
                  OutlinedButton(
                      onPressed: () {
                        GetIt.I<TodosProvider>().addTodo(
                            0, "titre", "description", false, DateTime.now());
                      },
                      child: Text("Valider")),
                  OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Annuler")),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
