import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/models/menu_jour.dart';
import 'package:heig_front/services/api.dart';
import 'package:heig_front/services/providers/menus_provider.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: GetIt.I.get<MenusProvider>(),
      child: Builder(builder: (context) {
        log(Provider.of<MenusProvider>(context).menus.toString());

        return Container(
          color: Theme.of(context).backgroundColor,
          child: Column(
            children: [
              ElevatedButton(
                child: const Text('get Menu'),
                onPressed: () async {
                  GetIt.I.get<MenusProvider>().fetchMenus();
                },
              ),
              if (Provider.of<MenusProvider>(context).menus.isNotEmpty)
                ...Provider.of<MenusProvider>(context)
                    .menus
                    .map((e) => MenuContainer(e))
                    .toList()
            ],
          ),
        );
      }),
    );
  }
}

class MenuContainer extends StatelessWidget {
  final MenuJour menuJour;
  const MenuContainer(this.menuJour, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      height: 100,
      width: 200,
      child: Column(
        children: menuJour.tradition.map((e) => Text(e)).toList(),
      ),
    );
  }
}
