import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';

class NotesDetails extends StatelessWidget {
  const NotesDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(VRouter.of(context).pathParameters['id'].toString()),
    );
  }
}
