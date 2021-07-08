import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';

class MyDrawer extends StatelessWidget {
  final Widget child;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  MyDrawer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HEIG Front'),
      ),
      body: child,
      drawer: Drawer(
        key: _scaffoldKey,
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Notes'),
              onTap: () {
                _scaffoldKey.currentState?.openEndDrawer();
                VRouter.of(context).to("/home/notes");
              },
            ),
            ListTile(
              title: Text('Horaire'),
              onTap: () {
                _scaffoldKey.currentState?.openEndDrawer();
                VRouter.of(context).to("/home/horaires");
              },
            ),
          ],
        ),
      ),
    );
  }
}
