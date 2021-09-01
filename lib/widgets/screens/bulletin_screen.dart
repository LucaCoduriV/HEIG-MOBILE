import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
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
    bool loading = context.watch<BulletinProvider>().loading;
    final thisYear = DateTime.now().year;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 20),
              Text("Année",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
              SizedBox(width: 10),
              DropdownButton<int>(
                style: TextStyle(
                    backgroundColor: Colors.white, color: Colors.black),
                value: Provider.of<BulletinProvider>(context).year,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                onChanged: (int? newValue) {
                  GetIt.I<BulletinProvider>().year = newValue;
                  GetIt.I<BulletinProvider>().fetchBulletin();
                },
                items: <int>[thisYear - 2, thisYear - 1, thisYear, thisYear + 1]
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child:
                        Text(value.toString() + "-" + (value + 1).toString()),
                  );
                }).toList(),
              ),
            ],
          ),
          Expanded(
            child: Column(
              children: [
                if (loading)
                  Center(
                    child: LinearProgressIndicator(
                      color: Colors.red,
                      backgroundColor: Colors.grey,
                    ),
                  ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) => RefreshIndicator(
                      color: Colors.red,
                      key: GetIt.I<GlobalKey<RefreshIndicatorState>>(),
                      onRefresh: () =>
                          GetIt.I<BulletinProvider>().fetchBulletin(),
                      child: buildButtons(context, bulletin, constraints),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButtons(context, Bulletin bulletin, BoxConstraints constraints) {
    if (bulletin.branches.length == 0)
      return SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: constraints.maxHeight, minWidth: constraints.maxWidth),
          child: Center(
            child: Text("Veuillez tirer vers le bas pour rafraichir."),
          ),
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
