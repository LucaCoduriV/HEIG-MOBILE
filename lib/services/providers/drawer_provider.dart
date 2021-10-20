import 'package:flutter/material.dart';
import 'package:modern_drawer/modern_drawer.dart';

enum ActionType {
  NONE,
  TODOS,
  Notes,
  QUICKINFOS,
}

class DrawerProvider extends ChangeNotifier {
  late String _title;
  late ActionType _action;
  final controller = ModernDrawerController();

  DrawerProvider() {
    _title = '';
    _action = ActionType.NONE;
  }

  set title(String title) {
    _title = title;
    notifyListeners();
  }

  set action(ActionType action) {
    _action = action;
    notifyListeners();
  }

  String get title => _title;
  ActionType get action => _action;
}
