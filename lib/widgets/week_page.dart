import 'package:flutter/material.dart';

import '../controllers/theme.dart' as theme;
import '../models/todo.dart';
import '../utils/date.dart';
import 'todo_info.dart';

class WeekPage extends StatelessWidget {
  final List<Todo> weekTasks;
  final DateTime firstDayOfWeek;
  const WeekPage(
      {Key? key, required this.weekTasks, required this.firstDayOfWeek})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lastDayOfWeek = firstDayOfWeek.add(const Duration(days: 6));
    return Column(
      children: [
        if (DateTime.now().firstDayOfWeek().day == firstDayOfWeek.day)
          const Text(
            'Cette semaine',
            style: TextStyle(fontSize: 30),
          ),
        const SizedBox(height: 10),
        Text(
            'Semaine du ${firstDayOfWeek.day} ${NOM_MOIS[firstDayOfWeek.month]} au ${lastDayOfWeek.day} ${NOM_MOIS[lastDayOfWeek.month]} ${lastDayOfWeek.year}'),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                buildTitle(context, 'Lundi'),
                ...buildTask(DateTime.monday),
                buildTitle(context, 'Mardi'),
                ...buildTask(DateTime.tuesday),
                buildTitle(context, 'Mercredi'),
                ...buildTask(DateTime.wednesday),
                buildTitle(context, 'Jeudi'),
                ...buildTask(DateTime.thursday),
                buildTitle(context, 'Vendredi'),
                ...buildTask(DateTime.friday),
                buildTitle(context, 'Samedi'),
                ...buildTask(DateTime.saturday),
                buildTitle(context, 'Dimanche'),
                ...buildTask(DateTime.sunday),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTitle(BuildContext context, String text) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.COLOR_PRIMARY)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 25),
      ),
    );
  }

  List<Widget> buildTask(int weekDay) {
    final dailyTasks =
        weekTasks.where((element) => element.date.weekday == weekDay);
    if (dailyTasks.isEmpty) {
      return [const Text('Aucune tâche')];
    }
    return dailyTasks.map((e) => TodoInfo(todo: e)).toList();
  }
}
