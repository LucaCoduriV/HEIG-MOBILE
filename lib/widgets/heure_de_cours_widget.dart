import 'package:flutter/material.dart';

/// Element d'une liste permettant d'afficher le début et la fin d'un cours.
class HeureDeCoursWidget extends StatelessWidget {
  final DateTime start;
  final DateTime end;
  final String title;
  final String salle;
  final String teacher;

  const HeureDeCoursWidget(
      this.start, this.end, this.title, this.salle, this.teacher,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    "${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const Text('-'),
                Text(
                    "${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          VerticalDivider(
            color: Colors.grey.shade200,
            thickness: 1,
          ),
          Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title),
                  const SizedBox(height: 5),
                  Text(teacher),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                      Text(salle),
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
