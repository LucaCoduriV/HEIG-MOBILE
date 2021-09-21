import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
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
      color: Theme.of(context).primaryColor,
      child: ListView(
        children: [
          SwitchListTile(
              title: Text(
                'Dark mode',
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color),
              ),
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
