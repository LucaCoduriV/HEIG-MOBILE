import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/services/providers/settings_provider.dart';
import 'package:provider/provider.dart';
import '../../settings/theme.dart' as theme;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: GetIt.I.get<SettingsProvider>(),
      builder: (context, _) => Container(
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
              },
            ),
            SwitchListTile(
              title: Text(
                'Afficher la moyenne',
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color),
              ),
              value: Provider.of<SettingsProvider>(context).showMoyenne,
              onChanged: (value) {
                GetIt.I.get<SettingsProvider>().showMoyenne =
                    !GetIt.I.get<SettingsProvider>().showMoyenne;
              },
            )
          ],
        ),
      ),
    );
  }
}
