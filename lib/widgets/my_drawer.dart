import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../controllers/drawer_provider.dart';
import '../controllers/navigator_controller.dart' as navigator_controller;
import '../controllers/theme.dart' as theme;
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
            elevation: 0,
            backgroundColor: theme.COLOR_BACKGROUND,
            title:
                Text(Provider.of<DrawerProvider>(context, listen: true).title),
            toolbarHeight: 100,
            actions: [
              if (GetIt.I<DrawerProvider>().action == ActionType.TODOS)
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Add a task',
                  onPressed: () {
                    showDialog(
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
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal),
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
              color: theme.COLOR_BACKGROUND,
              child: Column(
                children: <Widget>[
                  Expanded(
                    // ListView contains a group of widgets that scroll inside the drawer
                    child: ListView(
                      children: <Widget>[
                        DrawerHeader(
                          padding: EdgeInsets.zero,
                          decoration: const BoxDecoration(
                            color: theme.COLOR_SECONDARY,
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
                          leading: const Icon(Icons.home,
                              color: theme.COLOR_PRIMARY),
                          title: const Text('Home'),
                          onTap: () {
                            _scaffoldKey.currentState?.openEndDrawer();
                            navigator_controller.toHome(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.list,
                              color: theme.COLOR_PRIMARY),
                          title: const Text('Notes'),
                          onTap: () {
                            _scaffoldKey.currentState?.openEndDrawer();
                            navigator_controller.toNotes(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.timer,
                              color: theme.COLOR_PRIMARY),
                          title: const Text('Horaires'),
                          onTap: () {
                            _scaffoldKey.currentState?.openEndDrawer();
                            navigator_controller.toHoraires(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.calendar_today,
                              color: theme.COLOR_PRIMARY),
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
                            leading: const Icon(
                              Icons.settings,
                              color: theme.COLOR_TEXT_PRIMARY,
                            ),
                            title: const Text('Options'),
                            onTap: () {
                              _scaffoldKey.currentState?.openEndDrawer();
                              navigator_controller.toSettings(context);
                            },
                          ),
                          ListTile(
                              onTap: () {
                                GetIt.I<AuthController>().logout();
                                navigator_controller.toLogin(context);
                              },
                              leading: const Icon(
                                Icons.logout,
                                color: theme.COLOR_TEXT_PRIMARY,
                              ),
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
