import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../controllers/drawer_provider.dart';
import '../controllers/navigator_controller.dart';
import '../utils/date.dart';
import 'todos_dialog.dart';

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
            backgroundColor: const Color(0xFFF9F9FB),
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
            child: Column(
              children: <Widget>[
                Expanded(
                  // ListView contains a group of widgets that scroll inside the drawer
                  child: ListView(
                    children: <Widget>[
                      DrawerHeader(
                        padding: EdgeInsets.zero,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: double.infinity,
                              color: Colors.blue,
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
                        leading: Icon(Icons.home, color: Colors.red.shade500),
                        title: const Text('Home'),
                        onTap: () {
                          _scaffoldKey.currentState?.openEndDrawer();
                          NavigatorController.toHome(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.list, color: Colors.red.shade500),
                        title: const Text('Notes'),
                        onTap: () {
                          _scaffoldKey.currentState?.openEndDrawer();
                          NavigatorController.toNotes(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.timer, color: Colors.red.shade500),
                        title: const Text('Horaires'),
                        onTap: () {
                          _scaffoldKey.currentState?.openEndDrawer();
                          NavigatorController.toHoraires(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.calendar_today,
                            color: Colors.red.shade500),
                        title: const Text('Agenda'),
                        onTap: () {
                          _scaffoldKey.currentState?.openEndDrawer();
                          NavigatorController.toTodos(context);
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
                        const ListTile(
                            leading: Icon(Icons.settings),
                            title: Text('Options')),
                        ListTile(
                            onTap: () {
                              GetIt.I<AuthController>().logout();
                              NavigatorController.toLogin(context);
                            },
                            leading: const Icon(Icons.logout),
                            title: const Text('Se déconnecter'))
                      ],
                    ))
              ],
            ),
          ),
        );
      },
    );
  }
}
