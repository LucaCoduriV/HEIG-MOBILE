import 'package:flutter/material.dart';
import 'package:heig_front/utils/date.dart';

class WeekPage extends StatelessWidget {
  final List<List<Widget>> weekTasks;
  final DateTime firstDayOfWeek;
  const WeekPage(
      {Key? key, required this.weekTasks, required this.firstDayOfWeek})
      : super(key: key);

  static const test = [Text("test"), Text("test1"), Text("test2")];

  @override
  Widget build(BuildContext context) {
    final lastDayOfWeek = firstDayOfWeek.add(Duration(days: 6));
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
            "Semaine du ${firstDayOfWeek.day} ${NOM_MOIS[firstDayOfWeek.month]} au ${lastDayOfWeek.day} ${NOM_MOIS[lastDayOfWeek.month]} ${lastDayOfWeek.year}"),
        Expanded(
          child: ListView(
            children: [
              Text("Lundi"),
              ...weekTasks[0],
              Text("Mardi"),
              ...weekTasks[1],
              Text("Mercredi"),
              ...weekTasks[2],
              Text("Jeudi"),
              ...weekTasks[3],
              Text("Vendredi"),
              ...weekTasks[4],
              Text("Samedi"),
              ...weekTasks[5],
              Text("Dimanche"),
              ...weekTasks[6],
            ],
          ),
        ),
      ],
    );
  }
}
