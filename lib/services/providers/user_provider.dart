import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/user.dart';
import '../api_controller.dart';
import '../auth_controller.dart';

/// Cette classe permet de distribuer et mettre à jours les données concernant l'utilisateur.
class UserProvider extends ChangeNotifier {
  late User _user;
  var box = Hive.box('heig');

  UserProvider() {
    _user = box.get('user', defaultValue: User('', '', '', '', '', '', ''));
    if (_user.avatarUrl == '' && GetIt.I.get<AuthController>().isConnected) {
      fetchUser();
    }
  }

  User get user => _user;
  String get getAvatarUrl {
    if (_user.avatarUrl.length > 8) {
      return 'https://${GetIt.I.get<AuthController>().username}:${GetIt.I.get<AuthController>().password}@${_user.avatarUrl.substring(8)}';
    }
    return '';
  }

  Future<bool> fetchUser() async {
    final auth = GetIt.I.get<AuthController>();
    try {
      final password = await GetIt.I<AuthController>().encryptedPassword;

      _user = await ApiController()
          .fetchUser(auth.username, password, auth.gapsId, decrypt: true);
      box.put('user', _user);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  void clearUser() {
    _user = User('', '', '', '', '', '', '');
    box.put('user', _user);
    notifyListeners();
  }
}