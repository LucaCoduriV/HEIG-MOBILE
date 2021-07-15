import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/auth_controller.dart';
import 'package:heig_front/controllers/drawer_provider.dart';
import 'package:heig_front/controllers/navigator_controller.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(Provider.of<DrawerProvider>(context, listen: true).title),
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
                  ListTile(
                    title: Text('Notes'),
                    onTap: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                      NavigatorController.toNotes(context);
                    },
                  ),
                  ListTile(
                    title: Text('Horaires'),
                    onTap: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                      NavigatorController.toHoraires(context);
                    },
                  ),
                  ListTile(
                    title: Text('Todos'),
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
