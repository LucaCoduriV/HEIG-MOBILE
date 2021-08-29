import 'package:flutter/material.dart';

class BrancheButton extends StatelessWidget {
  final String title;
  final double moyenne;
  final void Function() onPress;
  const BrancheButton(
      {Key? key,
      required this.title,
      required this.moyenne,
      required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildButton();
  }

  Widget buildButton() {
    return InkWell(
      onTap: onPress,
      child: Container(
        child: buildButtonContent(),
        height: 70,
        margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: moyenne < 4 ? Color(0xFFFEF5F6) : Color(0xFFF4FEF8),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget buildButtonContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Text("Moyenne: $moyenne",
                style: TextStyle(fontWeight: FontWeight.w300)),
          ],
        ),
        Row(
          children: [
            SizedBox(width: 10),
            Icon(Icons.arrow_forward_ios_rounded),
          ],
        )
      ],
    );
  }
}
