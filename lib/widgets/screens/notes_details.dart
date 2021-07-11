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
        Text(bulletin.branches[id].nom),
        Expanded(
          child: ListView(
            children: [
              Text("Cours"),
              DataTable(
                columns: getColumn(),
                rows: getDatas(notesCours),
              ),
              Text("Laboratroires"),
              DataTable(
                columns: getColumn(),
                rows: getDatas(notesLabo),
              ),
            ],
          ),
        ),
      ],
    );
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
          DataCell(Text(e.coef)),
          DataCell(Text(e.note.toString())),
        ],
      );
    }).toList();
  }
}
