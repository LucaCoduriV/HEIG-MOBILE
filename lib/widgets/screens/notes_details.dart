import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/services/providers/settings_provider.dart';
import 'package:heig_front/utils/grades_functions.dart';
import 'package:provider/provider.dart';
import 'package:vrouter/vrouter.dart';

import '../../models/bulletin.dart';
import '../../models/notes.dart';
import '../../services/providers/bulletin_provider.dart';
import '../chart.dart';

/// Page contenant les notes d'une branche.
class NotesDetails extends StatelessWidget {
  const NotesDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int id =
        int.parse(VRouter.of(context).pathParameters['id'].toString());
    final Bulletin bulletin = GetIt.I<BulletinProvider>().bulletin;
    final List<Note> notesCours = bulletin.branches[id].cours;
    final List<Note> notesLabo = bulletin.branches[id].laboratoire;

    return ChangeNotifierProvider.value(
      value: GetIt.I.get<SettingsProvider>(),
      builder: (context, _) => Column(
        children: [
          Expanded(
            child: Container(
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.all(20),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children:
                    buildCoursAndLaboratoires(context, notesCours, notesLabo),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildCoursAndLaboratoires(
      BuildContext context, List<Note> notesCours, List<Note> notesLabo) {
    final laboMean = calculateMean(notesLabo);
    final coursMean = calculateMean(notesCours);
    final nextGradeLabo = getMinToGetMean(laboMean, 1);
    final nextGradeCours = getMinToGetMean(coursMean, 1);

    return [
      if (notesCours.isNotEmpty) ...[
        const Text(
          'Cours',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
        ),
        if (coursMean < 4)
          Text('Prochaine note minimum avec un coeff de 100%: $nextGradeCours'),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.only(right: 20),
          height: 200,
          width: double.infinity,
          child: Chart(
            notesCours.map((e) => e.note).toList(),
            notesCours.map((e) => e.moyenneClasse).toList(),
            showMoyenne: Provider.of<SettingsProvider>(context).showMoyenne,
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 30,
            columns: getColumn(context),
            rows: getDatas(notesCours),
          ),
        ),
        const SizedBox(height: 40),
      ],
      if (notesLabo.isNotEmpty) ...[
        const Text(
          'Laboratoires',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
        ),
        if (laboMean < 4)
          Text('Prochaine note minimum avec un coeff de 100%: $nextGradeLabo'),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.only(right: 20),
          height: 200,
          width: double.infinity,
          child: Chart(
            notesLabo.map((e) => e.note).toList(),
            notesLabo.map((e) => e.moyenneClasse).toList(),
            showMoyenne: Provider.of<SettingsProvider>(context).showMoyenne,
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 30,
            columns: getColumn(context),
            rows: getDatas(notesLabo),
          ),
        )
      ],
    ];
  }

  List<DataColumn> getColumn(BuildContext context) {
    return <DataColumn>[
      const DataColumn(
        label: Text(
          'Titre',
        ),
      ),
      DataColumn(
        numeric: true,
        label: Row(
          children: [
            const Text(
              'Moy.',
            ),
            Container(color: Colors.red, height: 10, width: 5)
          ],
        ),
      ),
      const DataColumn(
        label: Text(
          'coef.',
        ),
      ),
      DataColumn(
        numeric: true,
        label: Row(
          children: [
            const Text(
              'Notes',
            ),
            const SizedBox(
              width: 2,
            ),
            Container(color: Colors.cyan, height: 10, width: 5)
          ],
        ),
      ),
    ];
  }

  List<DataRow> getDatas(List<Note> notes) {
    return notes.map((e) {
      return DataRow(
        cells: <DataCell>[
          DataCell(
            Container(
              width: 100,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Text(
                  e.nom,
                  overflow: TextOverflow.clip,
                ),
              ),
            ),
          ),
          DataCell(Text(e.moyenneClasse.toString())),
          DataCell(Text('${e.coef.toString()}%')),
          DataCell(Text(e.note.toString())),
        ],
      );
    }).toList();
  }
}
