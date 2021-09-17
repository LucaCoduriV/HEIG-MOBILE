import 'package:flutter/material.dart';
import 'package:themed/themed.dart';
import '../../controllers/theme.dart' as theme;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Color bg = theme.COLOR_BACKGROUND;
  Color text = theme.COLOR_TEXT_PRIMARY;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bg,
      child: ListView(
        children: [
          SwitchListTile(
              title: Text(
                'Dark mode',
                style: TextStyle(color: text),
              ),
              value: Themed.ifCurrentThemeIs(theme.darkTheme),
              onChanged: (value) {
                if (!value) {
                  Themed.currentTheme = null;
                  setState(() {
                    bg = const Color(0xFFF9F9FB);
                    text = Colors.black;
                  });
                } else {
                  Themed.currentTheme = theme.darkTheme;
                  setState(() {
                    bg = const Color(0xFF121212);
                    text = Colors.white;
                  });
                }
              })
        ],
      ),
    );
  }
}
