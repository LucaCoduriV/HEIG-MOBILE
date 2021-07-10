import 'package:flutter/material.dart';

class BrancheButton extends StatelessWidget {
  final String title;
  final Function onPress;
  const BrancheButton({Key? key, required this.title, required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () {}, child: Text(title));
  }
}
