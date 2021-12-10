import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/models/menu_jour.dart';
import 'package:heig_front/services/api/iapi.dart';
import 'package:heig_front/utils/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MenusProvider extends ChangeNotifier {
  List<MenuJour> menus = [];
  final box = Hive.box(BOX_HEIG);
  final api = GetIt.I.get<IAPI>();

  MenusProvider() {
    final hiveMenu = box.get('menus', defaultValue: <MenuJour>[]);
    menus = hiveMenu;
  }

  Future<void> fetch() async {
    menus = await api.fetchMenuSemaine();
    notifyListeners();
  }
}
