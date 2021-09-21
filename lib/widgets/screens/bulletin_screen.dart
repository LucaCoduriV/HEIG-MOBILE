import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../controllers/bulletin_provider.dart';
import '../../controllers/drawer_provider.dart';
import '../../controllers/navigator_controller.dart' as navigator_controller;

import '../../models/branche.dart';
import '../../models/bulletin.dart';
import '../branche_button.dart';

/// Page contenant le bulletin de notes.
class BulletinScreen extends StatelessWidget {
  const BulletinScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: GetIt.I<BulletinProvider>(),
      builder: (context, _) {
        final Bulletin bulletin = context.watch<BulletinProvider>().bulletin;
        final bool loading = context.watch<BulletinProvider>().loading;
        final thisYear = DateTime.now().year;
        return Container(
          color: Theme.of(context).backgroundColor,
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 20),
                  const Text('Année',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
                  const SizedBox(width: 10),
                  DropdownButton<int>(
                    style: const TextStyle(
                        backgroundColor: Colors.white, color: Colors.black),
                    value: Provider.of<BulletinProvider>(context).year,
                    icon: const Icon(Icons.arrow_downward),
                    onChanged: (int? newValue) {
                      GetIt.I<BulletinProvider>().year = newValue!;
                      GetIt.I<BulletinProvider>().fetchBulletin();
                    },
                    items: <int>[
                      thisYear - 2,
                      thisYear - 1,
                      thisYear,
                      thisYear + 1
                    ].map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value-${value + 1}'),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  children: [
                    if (loading)
                      const Center(
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
      },
    );
  }

  Widget buildButtons(context, Bulletin bulletin, BoxConstraints constraints) {
    if (bulletin.branches.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: constraints.maxHeight, minWidth: constraints.maxWidth),
          child: const Center(
            child: Text('Veuillez tirer vers le bas pour rafraichir.'),
          ),
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
      itemCount: bulletin.branches.length,
      itemBuilder: (context, index) {
        final List<Branche> branches = bulletin.branches;

        return BrancheButton(
          title: branches[index].nom,
          moyenne: branches[index].moyenne,
          onPress: () {
            navigator_controller.toNoteDetails(context, index);
            GetIt.I<DrawerProvider>().title = bulletin.branches[index].nom;
          },
        );
      },
    );
  }
}
