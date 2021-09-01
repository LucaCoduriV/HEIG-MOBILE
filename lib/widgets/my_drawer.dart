import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/auth_controller.dart';
import 'package:heig_front/controllers/drawer_provider.dart';
import 'package:heig_front/controllers/navigator_controller.dart';
import 'package:heig_front/utils/date.dart';
import 'package:heig_front/widgets/todos_dialog.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatefulWidget {
  final Widget child;

  MyDrawer({Key? key, required this.child}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final image =
      Image(image: AssetImage('assets/images/logo-bar.png'), height: 70);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFF9F9FB),
        title: Text(Provider.of<DrawerProvider>(context, listen: true).title),
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
                    return TodosDialog();
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
                    style: TextStyle(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                          style: TextStyle(fontWeight: FontWeight.normal),
                          text: " " +
                              DateTime.now().day.toString() +
                              " " +
                              NOM_MOIS[DateTime.now().month])
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
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: double.infinity,
                          color: Colors.blue,
                          child: image,
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("HAUTE ÉCOLE",
                                style: TextStyle(fontSize: 15)),
                            const Text("D'INGÉNIERIE ET DE GESTION",
                                style: TextStyle(fontSize: 15)),
                            const Text("DU CANTON DE VAUD",
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
                      NavigatorController.toQuickInfos(context);
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
                    leading:
                        Icon(Icons.calendar_today, color: Colors.red.shade500),
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
            Container(
                // This align moves the children to the bottom
                child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    // This container holds all the children that will be aligned
                    // on the bottom and should not scroll with the above ListView
                    child: Container(
                        child: Column(
                      children: <Widget>[
                        Divider(),
                        ListTile(
                            leading: Icon(Icons.settings),
                            title: Text('Options')),
                        ListTile(
                            onTap: () {
                              GetIt.I<AuthController>().logout();
                              NavigatorController.toLogin(context);
                            },
                            leading: Icon(Icons.logout),
                            title: Text('Se déconnecter'))
                      ],
                    ))))
          ],
        ),
      ),
    );
  }
}
