import 'package:flutter/material.dart';
import 'package:themed/themed.dart';
import '../../controllers/theme_data.dart' as theme;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: ListView(
        children: [
          SwitchListTile(
              title: const Text('Dark mode'),
              value: true,
              onChanged: (value) {})
        ],
      ),
    );
  }
}
