import 'package:flutter/cupertino.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/services/api/iapi.dart';
import 'package:heig_front/utils/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/user.dart';
import '../auth/iauth.dart';

/// Cette classe permet de distribuer et mettre à jours les données concernant l'utilisateur.
class UserProvider extends ChangeNotifier {
  late User _user;
  final box = Hive.box(BOX_HEIG);
  final IAuth auth = GetIt.I.get<IAuth>();
  final IAPI api = GetIt.I.get<IAPI>();

  UserProvider() {
    _user = box.get('user', defaultValue: User('', '', '', '', '', '', ''));
    if (_user.avatarUrl == '' && auth.isConnected) {
      fetch();
    }
  }

  User get user => _user;
  String get getAvatarUrl {
    if (_user.avatarUrl.length > 8) {
      return 'https://${auth.username}:${auth.password}@${_user.avatarUrl.substring(8)}';
    }
    return '';
  }

  Future<bool> fetch() async {
    final auth = GetIt.I.get<IAuth>();
    try {
      final password = await auth.encryptedPassword;

      _user = await api.fetchUser(auth.username, password, auth.gapsId,
          decrypt: true);
      box.put('user', _user);
      notifyListeners();
      return true;
    } catch (e) {
      AlertController.show(
        'Erreur !',
        'Une erreur est survenue lors de la récupération de vos infos.',
        TypeAlert.error,
      );
      return false;
    }
  }

  void clearUser() {
    _user = User('', '', '', '', '', '', '');
    box.put('user', _user);
    notifyListeners();
  }
}
