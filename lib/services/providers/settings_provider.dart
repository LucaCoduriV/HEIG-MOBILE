import 'package:flutter/material.dart';
import 'package:heig_front/utils/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsProvider extends ChangeNotifier {
  late bool _showMoyenne;
  final box = Hive.box(BOX_SETTINGS);

  SettingsProvider() {
    _showMoyenne =
        box.get(BOX_SETTINGS_SHOW_MOYENNE, defaultValue: SHOW_MOYENNE);
  }

  bool get showMoyenne => _showMoyenne;

  set showMoyenne(bool showMoyenne) {
    _showMoyenne = showMoyenne;
    box.put(BOX_SETTINGS_SHOW_MOYENNE, showMoyenne);
    notifyListeners();
  }
}
