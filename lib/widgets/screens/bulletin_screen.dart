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
      key: GetIt.I<GlobalKey<RefreshIndicatorState>>(),
      onRefresh: () => GetIt.I<BulletinProvider>().fetchBulletin(
        GetIt.I<AuthController>().username,
        GetIt.I<AuthController>().password,
        GetIt.I<AuthController>().gapsId,
      ),
      child: Center(
        child: Container(
          color: Colors.white,
          child: buildButtons(context, bulletin),
        ),
      ),
    );
  }

  Widget buildButtons(context, Bulletin bulletin) {
    if (bulletin.branches.length == 0)
      return SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          child: Center(
            child: Text("Aucune notes, glissez vers le bas pour rafraichir."),
          ),
          height: MediaQuery.of(context).size.height,
        ),
      );

    return ListView.builder(
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
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
