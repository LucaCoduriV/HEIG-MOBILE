import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'api_controller.dart';
import 'asymmetric_crypt.dart';
import 'providers/bulletin_provider.dart';
import 'providers/user_provider.dart';

/// Cette classe permet de gérer le nom et le mot de passe de l'utilisateur
class AuthController extends ChangeNotifier {
  late String _username;
  late String _password;
  late int _gapsId;

  Future<String> get encryptedPassword async {
    final String publicKey = await GetIt.I<ApiController>().fetchPublicKey();
    return AsymmetricCrypt(publicKey).encrypt(_password);
  }

  var box = Hive.box('heig');

  bool get isConnected => gapsId != -1;

  set username(String username) {
    final box = Hive.box('heig');
    _username = username;
    box.put('username', username);
  }

  set password(String password) {
    _password = password;
    final box = Hive.box('heig');
    box.put('password', password);
  }

  String get username => _username;
  String get password => _password;
  int get gapsId => _gapsId;

  AuthController() {
    // Récupérer le nom et le mot de passe de l'utilisateur
    _username = box.get('username', defaultValue: '');
    _password = box.get('password', defaultValue: '');
    _gapsId = box.get('gapsId', defaultValue: -1);
  }

  Future<bool> login() async {
    final String password = await encryptedPassword;
    //ajouter la connection + le localstorage
    _gapsId = await GetIt.I<ApiController>()
        .login(_username, password, decrypt: true);

    box.put('gapsId', gapsId);

    notifyListeners();
    return isConnected;
  }

  Future<void> logout() async {
    // supprimer la connection + le localstorage
    box.delete('username');
    box.delete('password');
    box.delete('bulletin');
    box.delete('horaires');
    box.put('gapsId', -1);
    _gapsId = -1;
    _password = '';
    GetIt.I<BulletinProvider>().emptyBulletin();
    GetIt.I<UserProvider>().clearUser();
    notifyListeners();
    return;
  }
}
