import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/models/menu_jour.dart';
import 'package:heig_front/services/api.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MenusProvider extends ChangeNotifier {
  List<MenuJour> menus = [];
  final box = Hive.box('heig');

  MenusProvider() {
    final hiveMenu = box.get('menus', defaultValue: <MenuJour>[]);
    menus = hiveMenu;
  }

  Future<void> fetchMenus() async {
    menus = await GetIt.I.get<ApiController>().fetchMenuSemaine();
    notifyListeners();
  }
}
