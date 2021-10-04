import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/services/providers/horaires_provider.dart';
import 'package:provider/provider.dart';

import '../services/auth.dart';
import '../services/navigator_controller.dart' as navigator_controller;
import '../services/providers/drawer_provider.dart';
import '../settings/theme.dart' as theme;
import '../utils/date.dart';
import 'todos_dialog.dart';

/// Custom drawer contenant le logo de la HEIG ainsi que le menu.
class MyDrawer extends StatefulWidget {
  final Widget child;

  const MyDrawer({Key? key, required this.child}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
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
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            iconTheme: IconThemeData(
              color: Provider.of<theme.ThemeProvider>(context).mode ==
                      ThemeMode.light
                  ? Colors.black
                  : Colors.white,
            ),
            elevation: 0,
            title: Text(
              Provider.of<DrawerProvider>(context).title,
              style: TextStyle(
                color: Provider.of<theme.ThemeProvider>(context).mode ==
                        ThemeMode.light
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
                          color:
                              Provider.of<theme.ThemeProvider>(context).mode ==
                                      ThemeMode.light
                                  ? Colors.black
                                  : Colors.white,
                        ),
                        children: [
                          TextSpan(
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Provider.of<theme.ThemeProvider>(context)
                                            .mode ==
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
          ),
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
                                GetIt.I<AuthController>().logout();
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
}
