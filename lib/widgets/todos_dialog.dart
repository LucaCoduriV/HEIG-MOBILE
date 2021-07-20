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
  DateTime date = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      titlePadding: EdgeInsets.fromLTRB(20, 30, 20, 0),
      contentPadding: EdgeInsets.all(20),
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
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      "${date.day.toString()}/${date.month.toString()}/${date.year.toString()}"),
                  OutlinedButton(
                      onPressed: () async {
                        DateTime? _date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2050));
                        setState(() {
                          date = _date ?? DateTime.now();
                        });
                      },
                      child: Text("Choisir une date")),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
