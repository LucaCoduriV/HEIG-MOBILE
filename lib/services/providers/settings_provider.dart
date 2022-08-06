import 'package:flutter/material.dart';
import 'package:heig_front/utils/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsProvider extends ChangeNotifier {
  late bool _showMoyenne;
  late bool _showBatteryOptimizationAlert;
  final box = Hive.box(BOX_SETTINGS);

  SettingsProvider() {
    _showMoyenne =
        box.get(BOX_SETTINGS_SHOW_MOYENNE, defaultValue: SHOW_MOYENNE);
    _showBatteryOptimizationAlert = box.get(
        BOX_SETTINGS_SHOW_BATTERY_OPTIMIZATION_ALERT,
        defaultValue: SHOW_BATTERY_OPTIMIZATION_ALERT);
  }

  bool get showMoyenne => _showMoyenne;

  set showMoyenne(bool showMoyenne) {
    _showMoyenne = showMoyenne;
    box.put(BOX_SETTINGS_SHOW_MOYENNE, showMoyenne);
    notifyListeners();
  }

  bool get showBatteryOptimizationAlert => _showBatteryOptimizationAlert;

  set showBatteryOptimizationAlert(bool showBatteryOptimizationAlert) {
    _showBatteryOptimizationAlert = showBatteryOptimizationAlert;
    box.put(BOX_SETTINGS_SHOW_BATTERY_OPTIMIZATION_ALERT,
        showBatteryOptimizationAlert);
    notifyListeners();
  }
}
