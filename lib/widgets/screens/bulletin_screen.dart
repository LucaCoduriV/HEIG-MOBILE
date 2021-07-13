import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/auth_controller.dart';
import 'package:heig_front/controllers/bulletin_provider.dart';
import 'package:heig_front/controllers/drawer_provider.dart';
import 'package:heig_front/controllers/navigator_controller.dart';
import 'package:heig_front/models/branche.dart';
import 'package:heig_front/models/bulletin.dart';
import 'package:heig_front/widgets/branche_button.dart';
import 'package:provider/provider.dart';

class BulletinScreen extends StatelessWidget {
  const BulletinScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Bulletin bulletin = context.watch<BulletinProvider>().bulletin;

    return RefreshIndicator(
      onRefresh: () => GetIt.I<BulletinProvider>().fetchBulletin(
          GetIt.I<AuthController>().username,
          GetIt.I<AuthController>().password),
      child: Center(
        child: buildButtons(bulletin),
      ),
    );
  }

  Widget buildButtons(Bulletin bulletin) {
    if (bulletin.branches.length == 0)
      return Text("Aucune notes, glissez vers le bas pour rafraichir.");
    return ListView.builder(
      itemCount: bulletin.branches.length,
      itemBuilder: (context, index) {
        List<Branche> branches = bulletin.branches;
        return BrancheButton(
          title: branches[index].nom,
          moyenne: branches[index].moyenne,
          onPress: () {
            NavigatorController.toNoteDetails(context, index);
            GetIt.I<DrawerProvider>().title = bulletin.branches[index].nom;
          },
        );
      },
    );
  }
}
