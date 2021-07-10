import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:heig_front/controllers/api_controller.dart';
import 'package:heig_front/models/bulletin.dart';
import 'package:heig_front/widgets/branche_button.dart';
import 'package:vrouter/vrouter.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: ApiController().fetchNotes(dotenv.env['USERNAME'].toString(),
            dotenv.env['PASSWORD'].toString()),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          if (snapshot.hasError) return Text("Error while fetching data");
          return ListView(
            children: (snapshot.data as Bulletin)
                .notes
                .map((e) => BrancheButton(
                      title: e.nom,
                      onPress: () {
                        VRouter.of(context).to("/horaires/1");
                      },
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}
