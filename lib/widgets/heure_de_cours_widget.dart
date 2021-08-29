import 'package:flutter/material.dart';

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
        color: Color(0xFFF9F9FB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${start.hour}:${start.minute}",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text("-"),
                Text("${end.hour}:${end.minute}",
                    style: TextStyle(fontWeight: FontWeight.bold)),
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
                  SizedBox(height: 5),
                  Text(teacher),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on_outlined),
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
