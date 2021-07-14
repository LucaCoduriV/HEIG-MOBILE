import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/bulletin_provider.dart';
import 'package:heig_front/models/bulletin.dart';
import 'package:heig_front/models/notes.dart';
import 'package:vrouter/vrouter.dart';

class NotesDetails extends StatelessWidget {
  const NotesDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int id = int.parse(VRouter.of(context).pathParameters['id'].toString());
    Bulletin bulletin = GetIt.I<BulletinProvider>().bulletin;
    List<Note> notesCours = bulletin.branches[id].cours;
    List<Note> notesLabo = bulletin.branches[id].laboratoire;

    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: getChildren(context, notesCours, notesLabo),
            ),
          ),
        ),
      ],
    );
  }

  // TODO refactor this fucntion
  List<Widget> getChildren(
      context, List<Note> notesCours, List<Note> notesLabo) {
    return [
      if (notesCours.isNotEmpty)
        Text(
          "Cours",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
        ),
      if (notesCours.isNotEmpty) SizedBox(height: 10),
      if (notesCours.isNotEmpty)
        DataTable(
          columnSpacing: 30,
          columns: getColumn(),
          rows: getDatas(notesCours),
        ),
      if (notesCours.isNotEmpty) SizedBox(height: 40),
      if (notesLabo.isNotEmpty)
        Text(
          "Laboratoires",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
        ),
      if (notesLabo.isNotEmpty) SizedBox(height: 10),
      if (notesLabo.isNotEmpty)
        DataTable(
          columnSpacing: 30,
          columns: getColumn(),
          rows: getDatas(notesLabo),
        ),
    ];
  }

  List<DataColumn> getColumn() {
    return <DataColumn>[
      DataColumn(
        label: Text(
          'Titre',
        ),
      ),
      DataColumn(
        label: Text(
          'Moyenne',
        ),
      ),
      DataColumn(
        label: Text(
          'coef',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      DataColumn(
        label: Text(
          'Notes',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
    ];
  }

  List<DataRow> getDatas(List<Note> notes) {
    return notes.map((e) {
      return DataRow(
        cells: <DataCell>[
          DataCell(Text(e.nom)),
          DataCell(Text(e.moyenneClasse.toString())),
          DataCell(Text("${e.coef.toString()}%")),
          DataCell(Text(e.note.toString())),
        ],
      );
    }).toList();
  }
}
