import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/services/auth/iauth.dart';
import 'package:heig_front/services/providers/horaires_provider.dart';
import 'package:modern_drawer/modern_drawer.dart';
import 'package:provider/provider.dart';

import '../services/navigation.dart' as navigator_controller;
import '../services/providers/drawer_provider.dart';
import '../settings/theme.dart' as theme;
import '../utils/date.dart';
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
          backgroundColor:
              Provider.of<theme.ThemeProvider>(context).mode == ThemeMode.dark
                  ? const Color(0xff242424)
                  : const Color(0xfffafafa),
          bodyBoxShadows: const [
            BoxShadow(
              blurRadius: 12,
              spreadRadius: 1,
            ), //BoxShadow
          ],
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
      leading: Icon(
        icon,
        color: Theme.of(context).accentColor,
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
                  const Divider(),
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
      iconTheme: IconThemeData(
        color: Provider.of<theme.ThemeProvider>(context).mode == ThemeMode.light
            ? Colors.black
            : Colors.white,
      ),
      elevation: 0,
      title: Text(
        Provider.of<DrawerProvider>(context).title,
        style: TextStyle(
          color:
              Provider.of<theme.ThemeProvider>(context).mode == ThemeMode.light
                  ? Colors.black
                  : Colors.white,
        ),
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
                    color: Provider.of<theme.ThemeProvider>(context).mode ==
                            ThemeMode.light
                        ? Colors.black
                        : Colors.white,
                  ),
                  children: [
                    TextSpan(
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color:
                              Provider.of<theme.ThemeProvider>(context).mode ==
                                      ThemeMode.light
                                  ? Colors.black
                                  : Colors.white,
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

/// Custom drawer contenant le logo de la HEIG ainsi que le menu.
class MyDrawerOld extends StatefulWidget {
  final Widget child;

  const MyDrawerOld({Key? key, required this.child}) : super(key: key);

  @override
  State<MyDrawerOld> createState() => _MyDrawerOldState();
}

class _MyDrawerOldState extends State<MyDrawerOld> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final image =
      const Image(image: AssetImage('assets/images/logo-bar.png'), height: 70);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: GetIt.I<DrawerProvider>(),
      builder: (context, child) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: buildAppBar(context),
          body: widget.child,
          drawer: Drawer(
            child: Container(
              color: Theme.of(context).backgroundColor,
              child: Column(
                children: <Widget>[
                  Expanded(
                    // ListView contains a group of widgets that scroll inside the drawer
                    child: ListView(
                      children: <Widget>[
                        DrawerHeader(
                          padding: EdgeInsets.zero,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: double.infinity,
                                child: image,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text('HAUTE ÉCOLE',
                                      style: TextStyle(fontSize: 15)),
                                  Text("D'INGÉNIERIE ET DE GESTION",
                                      style: TextStyle(fontSize: 15)),
                                  Text('DU CANTON DE VAUD',
                                      style: TextStyle(fontSize: 15)),
                                ],
                              )
                            ],
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.home,
                            color: Theme.of(context).accentColor,
                          ),
                          title: const Text('Home'),
                          onTap: () {
                            _scaffoldKey.currentState?.openEndDrawer();
                            navigator_controller.toHome(context);
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.list,
                            color: Theme.of(context).accentColor,
                          ),
                          title: const Text('Notes'),
                          onTap: () {
                            _scaffoldKey.currentState?.openEndDrawer();
                            navigator_controller.toNotes(context);
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.timer,
                            color: Theme.of(context).accentColor,
                          ),
                          title: const Text('Horaires'),
                          onTap: () {
                            _scaffoldKey.currentState?.openEndDrawer();
                            navigator_controller.toHoraires(context);
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.calendar_today,
                            color: Theme.of(context).accentColor,
                          ),
                          title: const Text('Agenda'),
                          onTap: () {
                            _scaffoldKey.currentState?.openEndDrawer();
                            navigator_controller.toTodos(context);
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.food_bank,
                            color: Theme.of(context).accentColor,
                          ),
                          title: const Text('Menu'),
                          onTap: () {
                            _scaffoldKey.currentState?.openEndDrawer();
                            navigator_controller.toMenu(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  // This container holds the align
                  Align(
                      alignment: FractionalOffset.bottomCenter,
                      // This container holds all the children that will be aligned
                      // on the bottom and should not scroll with the above ListView
                      child: Column(
                        children: <Widget>[
                          const Divider(),
                          ListTile(
                            leading: Icon(Icons.settings,
                                color: Theme.of(context).iconTheme.color),
                            title: const Text('Options'),
                            onTap: () {
                              _scaffoldKey.currentState?.openEndDrawer();
                              navigator_controller.toSettings(context);
                            },
                          ),
                          ListTile(
                              onTap: () {
                                GetIt.I<IAuth>().logout();
                                GetIt.I
                                    .get<HorairesProvider>()
                                    .cancelNotifications();
                                navigator_controller.toLogin(context);
                              },
                              leading: Icon(Icons.logout,
                                  color: Theme.of(context).iconTheme.color),
                              title: const Text('Se déconnecter'))
                        ],
                      ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      iconTheme: IconThemeData(
        color: Provider.of<theme.ThemeProvider>(context).mode == ThemeMode.light
            ? Colors.black
            : Colors.white,
      ),
      elevation: 0,
      title: Text(
        Provider.of<DrawerProvider>(context).title,
        style: TextStyle(
          color:
              Provider.of<theme.ThemeProvider>(context).mode == ThemeMode.light
                  ? Colors.black
                  : Colors.white,
        ),
      ),
      toolbarHeight: 100,
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
                    color: Provider.of<theme.ThemeProvider>(context).mode ==
                            ThemeMode.light
                        ? Colors.black
                        : Colors.white,
                  ),
                  children: [
                    TextSpan(
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color:
                              Provider.of<theme.ThemeProvider>(context).mode ==
                                      ThemeMode.light
                                  ? Colors.black
                                  : Colors.white,
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
