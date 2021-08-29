import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/api_controller.dart';
import 'package:heig_front/controllers/auth_controller.dart';
import 'package:heig_front/models/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserProvider extends ChangeNotifier {
  late User _user;
  var box = Hive.box('heig');

  UserProvider() {
    _user = box.get('user', defaultValue: User("", "", "", "", "", "", ""));
    if (_user.avatarUrl == "" && GetIt.I.get<AuthController>().isConnected)
      fetchUser(
          GetIt.I.get<AuthController>().username,
          GetIt.I.get<AuthController>().password,
          GetIt.I.get<AuthController>().gapsId);
  }

  User get user => _user;
  String get getAvatarUrl {
    if (_user.avatarUrl.length > 8)
      return "https://" +
          GetIt.I.get<AuthController>().username +
          ":" +
          GetIt.I.get<AuthController>().password +
          "@" +
          _user.avatarUrl.substring(8);
    return "";
  }

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