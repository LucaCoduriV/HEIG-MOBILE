import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/branche_provider.dart';
import 'package:heig_front/controllers/navigator_controller.dart';
import 'package:heig_front/models/branche.dart';
import 'package:heig_front/models/bulletin.dart';
import 'package:heig_front/widgets/branche_button.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder(
        stream: GetIt.I<BulletinProvider>().getBulletin(
            dotenv.env['USERNAME'].toString(),
            dotenv.env['PASSWORD'].toString()),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          if (snapshot.hasError) return Text("Error while fetching data");
          return ListView.builder(
            itemCount: (snapshot.data as Bulletin).branches.length,
            itemBuilder: (context, index) {
              List<Branche> branches = (snapshot.data as Bulletin).branches;
              return BrancheButton(
                title: branches[index].nom,
                onPress: () {
                  NavigatorController.toNoteDetails(context, index);
                },
              );
            },
          );
        },
      ),
    );
  }
}
