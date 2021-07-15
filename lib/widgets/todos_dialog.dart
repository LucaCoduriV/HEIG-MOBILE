import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/todos_provider.dart';

class TodosDialog extends StatefulWidget {
  const TodosDialog({Key? key}) : super(key: key);

  @override
  _TodosDialogState createState() => _TodosDialogState();
}

class _TodosDialogState extends State<TodosDialog> {
  TextEditingController title = new TextEditingController();
  TextEditingController description = new TextEditingController();
  DateTime? date = new DateTime.now();

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
                controller: title,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Description"),
                controller: description,
              ),
              Row(
                children: [
                  Text(date.toString()),
                  OutlinedButton(
                      onPressed: () async {
                        DateTime? _date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2050));
                        setState(() {
                          date = _date;
                        });
                      },
                      child: Text("Select date")),
                ],
              ),
              Row(
                children: [
                  OutlinedButton(
                      onPressed: () {
                        GetIt.I<TodosProvider>().addTodo(
                            0, title.text, description.text, false, date);
                        Navigator.of(context).pop();
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
