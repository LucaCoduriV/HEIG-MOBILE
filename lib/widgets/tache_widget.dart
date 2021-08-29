import 'package:flutter/material.dart';

class TacheWidget extends StatelessWidget {
  final String title;
  final DateTime start;
  final String description;

  const TacheWidget(this.title, this.start, this.description, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Duration leftDays = start.difference(DateTime.now());
    String remainingTime;
    if (start.day == DateTime.now().day &&
        start.month == DateTime.now().month &&
        start.year == DateTime.now().year) {
      remainingTime = 'Aujourd\'hui';
    } else {
      remainingTime = leftDays.inDays < 1
          ? 'Dans ${leftDays.inHours} heures'
          : 'Dans ${leftDays.inDays} jours';
    }

    return Container(
      width: 150,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Deadline",
              style: const TextStyle(
                  fontWeight: FontWeight.w400, color: Colors.white)),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              SizedBox(width: 6),
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
