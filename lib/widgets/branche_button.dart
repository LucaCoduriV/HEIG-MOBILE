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
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: buildButton(),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        )
      ],
    );
  }

  Widget buildButton() {
    return InkWell(
      onTap: onPress,
      child: Container(
        child: buildButtonContent(),
        height: 100,
        margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtonContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 16)),
            Row(
              children: [
                Text("Moyenne: $moyenne"),
                SizedBox(width: 10),
                Icon(Icons.arrow_forward_ios_rounded),
              ],
            )
          ],
        )
      ],
    );
  }
}
