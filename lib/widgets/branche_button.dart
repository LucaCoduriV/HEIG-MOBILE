import 'package:flutter/material.dart';

class BrancheButton extends StatelessWidget {
  final String title;
  final void Function() onPress;
  const BrancheButton({Key? key, required this.title, required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(onPressed: onPress, child: Text(title)),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
