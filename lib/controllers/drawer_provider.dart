import 'package:flutter/material.dart';

enum ActionType {
  NONE,
  TODOS,
}

class DrawerProvider extends ChangeNotifier {
  late String _title;
  late ActionType _action;

  DrawerProvider() {
    this._title = "";
    _action = ActionType.NONE;
  }

  set title(title) {
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
