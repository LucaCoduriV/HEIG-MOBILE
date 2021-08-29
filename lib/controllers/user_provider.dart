import 'package:flutter/cupertino.dart';
import 'package:heig_front/controllers/api_controller.dart';
import 'package:heig_front/models/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserProvider extends ChangeNotifier {
  late User _user;
  var box = Hive.box('heig');

  UserProvider() {
    _user = box.get('user', defaultValue: User("", "", "", "", "", "", ""));
  }

  User get user => _user;

  Future<bool> fetchUser(String username, String password, int gapsId) async {
    try {
      _user = await ApiController().fetchUser(username, password, gapsId);
      debugPrint(_user.toString());
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}
