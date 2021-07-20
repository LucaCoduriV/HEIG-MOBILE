import 'package:flutter/material.dart';
import 'package:heig_front/models/todo.dart';
import 'package:heig_front/utils/date.dart';
import 'package:heig_front/widgets/task_info.dart';

class WeekPage extends StatelessWidget {
  final List<Todo> weekTasks;
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
              ...buildTask(DateTime.monday),
              Text("Mardi"),
              ...buildTask(DateTime.tuesday),
              Text("Mercredi"),
              ...buildTask(DateTime.wednesday),
              Text("Jeudi"),
              ...buildTask(DateTime.thursday),
              Text("Vendredi"),
              ...buildTask(DateTime.friday),
              Text("Samedi"),
              ...buildTask(DateTime.saturday),
              Text("Dimanche"),
              ...buildTask(DateTime.sunday),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> buildTask(int weekDay) {
    final dailyTasks =
        weekTasks.where((element) => element.date.weekday == weekDay);

    return dailyTasks.map((e) => TaskInfo(todo: e, index: 0)).toList();
  }
}
