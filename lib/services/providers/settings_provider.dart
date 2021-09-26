import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsProvider extends ChangeNotifier {
  late bool _showMoyenne;
  final box = Hive.box('heig-settings');

  SettingsProvider() {
    _showMoyenne = box.get('showMoyenne', defaultValue: true);
  }

  bool get showMoyenne => _showMoyenne;

  set showMoyenne(bool showMoyenne) {
    _showMoyenne = showMoyenne;
    box.put('showMoyenne', showMoyenne);
    notifyListeners();
  }
}
