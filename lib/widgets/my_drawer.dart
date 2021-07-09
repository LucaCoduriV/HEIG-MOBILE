import 'package:flutter/material.dart';
import 'package:heig_front/controllers/navigator_controller.dart';

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
        title: Text('HEIG Front'),
      ),
      body: widget.child,
      drawer: Drawer(
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
              title: Text('Horaire'),
              onTap: () {
                _scaffoldKey.currentState?.openEndDrawer();
                NavigatorController.toHoraires(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
