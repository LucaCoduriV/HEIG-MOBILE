import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/theme_data.dart' as theme;

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
                    "${start.hour}:${start.minute}${start.minute == 0 ? '0' : ''}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const Text('-'),
                Text("${end.hour}:${end.minute}${end.minute == 0 ? '0' : ''}",
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
                        color: Provider.of<theme.ThemeProvider>(context).mode ==
                                ThemeMode.light
                            ? Colors.black
                            : Colors.white,
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
