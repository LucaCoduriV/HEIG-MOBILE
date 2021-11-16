import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// const COLOR_PRIMARY = ColorRef(Color(0xffda291c));
const COLOR_PRIMARY_LIGHT = Color(0xFFFF8A80);
const COLOR_PRIMARY_LIGHT_LIGHT = Color(0xFFFEF5F6);
// const COLOR_PRIMARY_ACCENT = ColorRef(Color(0xffdf4d52));
// const COLOR_SECONDARY = ColorRef(Color(0xFFFFFFFF));
const COLOR_GREY = Color(0xFF9E9E9E);
// const COLOR_BACKGROUND = ColorRef(Color(0xFFF9F9FB));
const COLOR_GREEN = Color(0xFF4CAF50);
const COLOR_GREEN_LIGHT = Color(0xFFA5D6A7);
const COLOR_GREEN_LIGHT_LIGHT = Color(0xFFF4FEF8);
// const COLOR_TEXT_PRIMARY = ColorRef(Color(0xFF000000));

ThemeData themeLight = ThemeData.light().copyWith(
  textTheme: const TextTheme(
    bodyText1: TextStyle(),
    bodyText2: TextStyle(),
  ).apply(
    bodyColor: const Color(0xFF000000),
    displayColor: const Color(0xFF000000),
  ),
  iconTheme: const IconThemeData(color: Color(0xFF000000)),
  textSelectionTheme:
      const TextSelectionThemeData(cursorColor: Color(0xFF9E9E9E)),
  primaryColor: const Color(0xFFF9F9FB),
  backgroundColor: const Color(0xFFFFFFFF),
  colorScheme: const ColorScheme.light(
    secondary: Color(0xffdf4d52),
  ),
  inputDecorationTheme: const InputDecorationTheme(
      focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Color(0xffda291c)),
  )),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xffda291c),
    textTheme: ButtonTextTheme.primary,
  ),
);

ThemeData themeDark = ThemeData.dark().copyWith(
  textTheme: const TextTheme(
    bodyText1: TextStyle(),
    bodyText2: TextStyle(),
  ).apply(
    bodyColor: const Color(0x99FFFFFF),
    displayColor: const Color(0x99FFFFFF),
  ),
  iconTheme: const IconThemeData(color: Color(0xFFFFFFFF)),
  textSelectionTheme:
      const TextSelectionThemeData(cursorColor: Color(0xFF9E9E9E)),
  primaryColor: const Color(0xFF121212),
  backgroundColor: const Color(0xFF232323),
  colorScheme: const ColorScheme.dark(
    secondary: Color(0xffdf4d52),
  ),
  inputDecorationTheme: const InputDecorationTheme(
      focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Color(0xffda291c)),
  )),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xffda291c),
    textTheme: ButtonTextTheme.primary,
  ),
);

class ThemeProvider extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;
  var box = Hive.box('heig');

  ThemeProvider() {
    final themeModeId = box.get('theme', defaultValue: 1);
    _mode = ThemeMode.values[themeModeId];
  }

  set mode(ThemeMode mode) {
    box.put('theme', mode.index);
    _mode = mode;
    notifyListeners();
  }

  ThemeMode get mode => _mode;
}

// Map<ThemeRef, Object> darkTheme = {
//   COLOR_PRIMARY: const Color(0xffda291c),
//   COLOR_PRIMARY_LIGHT: const Color(0xFFFF8A80),
//   COLOR_PRIMARY_ACCENT: const Color(0xffdf4d52),
//   COLOR_SECONDARY: const Color(0xFF1E1E1E),
//   COLOR_GREY: const Color(0xFF9E9E9E),
//   COLOR_BACKGROUND: const Color(0xFF121212),
//   COLOR_TEXT_PRIMARY: const Color(0xFFFFFFFF),
// };

// var test = Color(0xffda291c);
// var test1 = Color(0xffdf4d52);
// var test2 = Colors.white;
// var test3 = Colors.grey;
// var test4 = Color(0xFFF9F9FB);
// var test5 = Colors.redAccent;
// var test6 = Colors.redAccent.shade100;
// var test7 = Colors.red.shade200;
// var test8 = Colors.grey;
