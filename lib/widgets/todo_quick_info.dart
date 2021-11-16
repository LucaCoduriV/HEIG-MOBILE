import 'package:flutter/material.dart';
import '../settings/theme.dart' as theme;

/// Affiche les informations d'une tâche pour la page d'acceuil.
class TodoQuickInfo extends StatelessWidget {
  final String title;
  final DateTime start;
  final String description;

  const TodoQuickInfo(this.title, this.start, this.description, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Duration leftDays = start.difference(DateTime.now());
    String remainingTime;
    if (start.day == DateTime.now().day &&
        start.month == DateTime.now().month &&
        start.year == DateTime.now().year) {
      remainingTime = "Aujourd'hui";
    } else if (leftDays.inDays >= 0) {
      remainingTime = leftDays.inDays < 1
          ? 'Dans ${leftDays.inHours} heures'
          : 'Dans ${leftDays.inDays} jours';
    } else {
      remainingTime = 'En retard';
    }

    return Container(
      width: 150,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: leftDays.inDays < 2
            ? theme.COLOR_PRIMARY_LIGHT
            : theme.COLOR_GREEN_LIGHT,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Deadline',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).backgroundColor)),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  color: leftDays.inDays < 2
                      ? Theme.of(context).colorScheme.secondary
                      : theme.COLOR_GREEN,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 6),
              Text(remainingTime),
            ],
          ),
          const SizedBox(height: 20),
          Text(title),
          const SizedBox(height: 10),
          Text(description),
        ],
      ),
    );
  }
}
