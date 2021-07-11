import 'package:flutter/material.dart';

class DrawerProvider extends ChangeNotifier {
  late String _title;

  DrawerProvider(String title) {
    this._title = title;
  }

  set title(title) {
    _title = title;
    notifyListeners();
  }

  get title => _title;
}
