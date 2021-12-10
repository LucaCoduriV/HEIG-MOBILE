import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/services/auth/iauth.dart';
import 'package:heig_front/services/providers/horaires_provider.dart';
import 'package:modern_drawer/modern_drawer.dart';
import 'package:provider/provider.dart';

import '../services/providers/drawer_provider.dart';
import '../settings/theme.dart' as theme;
import '../utils/date.dart';
import '../utils/navigation.dart' as navigator_controller;
import 'todos_dialog.dart';

class MyDrawer extends StatelessWidget {
  final Widget child;
  const MyDrawer({Key? key, required this.child}) : super(key: key);

  static final Widget _svg = SvgPicture.asset(
    'assets/images/logo.svg',
    semanticsLabel: 'HEIG Logo',
    width: 100,
    color: const Color(0xffda291c), //Theme.of(context).primaryColor,
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: GetIt.I<DrawerProvider>(),
      builder: (context, child) {
        return ModernDrawer(
          elevation: 10,
          backgroundColor:
              Provider.of<theme.ThemeProvider>(context).mode == ThemeMode.dark
                  ? const Color(0xff121212)
                  : const Color(0xfffafafa),
          controller: GetIt.I<DrawerProvider>().controller,
          appBar: buildAppBar(context),
          drawerContent: buildDrawerContent(context),
          body: child,
        );
      },
      child: child,
    );
  }

  Widget buildListTile(BuildContext context, String title, IconData icon,
      void Function()? onTap) {
    return ListTile(
      minLeadingWidth: 0,
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.secondary,
        size: 23,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14),
      ),
      onTap: onTap,
    );
  }

  Widget buildDrawerContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _svg,
          const SizedBox(height: 30),
          buildListTile(context, 'Home', Icons.home, () {
            navigator_controller.toHome(context);
            GetIt.I<DrawerProvider>().controller.closeDrawer();
          }),
          buildListTile(context, 'Notes', Icons.list, () {
            navigator_controller.toNotes(context);
            GetIt.I<DrawerProvider>().controller.closeDrawer();
          }),
          buildListTile(context, 'Horaires', Icons.timer, () {
            navigator_controller.toHoraires(context);
            GetIt.I<DrawerProvider>().controller.closeDrawer();
          }),
          buildListTile(context, 'Agenda', Icons.calendar_today, () {
            navigator_controller.toTodos(context);
            GetIt.I<DrawerProvider>().controller.closeDrawer();
          }),
          buildListTile(context, 'Menu', Icons.food_bank, () {
            navigator_controller.toMenu(context);
            GetIt.I<DrawerProvider>().controller.closeDrawer();
          }),
          Align(
              alignment: FractionalOffset.bottomCenter,
              // This container holds all the children that will be aligned
              // on the bottom and should not scroll with the above ListView
              child: Column(
                children: <Widget>[
                  buildListTile(context, 'Options', Icons.settings, () {
                    navigator_controller.toSettings(context);
                    GetIt.I<DrawerProvider>().controller.closeDrawer();
                  }),
                  buildListTile(context, 'Se déconnecter', Icons.logout, () {
                    GetIt.I<IAuth>().logout();
                    GetIt.I.get<HorairesProvider>().cancelNotifications();
                    navigator_controller.toLogin(context);
                  }),
                ],
              ))
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      iconTheme:
          IconThemeData(color: Theme.of(context).textTheme.bodyText1!.color),
      elevation: 0,
      title: Text(
        Provider.of<DrawerProvider>(context).title,
        style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
      ),
      toolbarHeight: 100,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          GetIt.I<DrawerProvider>().controller.openDrawer();
        },
      ),
      actions: [
        if (GetIt.I<DrawerProvider>().action == ActionType.TODOS)
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add a task',
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return const TodosDialog();
                },
              );
            },
          ),
        if (GetIt.I<DrawerProvider>().action == ActionType.QUICKINFOS)
          Container(
            padding: const EdgeInsets.only(right: 15),
            child: Center(
              child: Text.rich(
                TextSpan(
                  text: NOM_JOURS_SEMAINE[DateTime.now().weekday],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                  children: [
                    TextSpan(
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                        text:
                            ' ${DateTime.now().day} ${NOM_MOIS[DateTime.now().month]}')
                  ],
                ),
              ),
            ),
          )
      ],
    );
  }
}
