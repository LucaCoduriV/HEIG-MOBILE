import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
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
              value: GetIt.I.get<theme.ThemeProvider>().mode == ThemeMode.dark,
              onChanged: (value) {
                if (GetIt.I.get<theme.ThemeProvider>().mode == ThemeMode.dark) {
                  GetIt.I.get<theme.ThemeProvider>().mode = ThemeMode.light;
                } else {
                  GetIt.I.get<theme.ThemeProvider>().mode = ThemeMode.dark;
                }
              })
        ],
      ),
    );
  }
}
