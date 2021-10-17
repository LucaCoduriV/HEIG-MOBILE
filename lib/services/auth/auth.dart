import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../api/iapi.dart';
import '../asymmetric_crypt.dart';
import '../providers/bulletin_provider.dart';
import '../providers/user_provider.dart';
import 'iauth.dart';

/// Cette classe permet de gérer le nom et le mot de passe de l'utilisateur
class Auth extends ChangeNotifier implements IAuth {
  late String _username;
  late String _password;
  late int _gapsId;

  final api = GetIt.I.get<IAPI>();

  @override
  Future<String> get encryptedPassword async {
    final String publicKey = await api.fetchPublicKey();
    return AsymmetricCrypt(publicKey).encrypt(_password);
  }

  var box = Hive.box('heig');

  @override
  bool get isConnected => gapsId != -1;

  @override
  set username(String username) {
    final box = Hive.box<dynamic>('heig');
    _username = username;
    box.put('username', username);
  }

  @override
  set password(String password) {
    _password = password;
    final box = Hive.box<dynamic>('heig');
    box.put('password', password);
  }

  @override
  String get username => _username;
  @override
  String get password => _password;
  @override
  int get gapsId => _gapsId;

  Auth() {
    // Récupérer le nom et le mot de passe de l'utilisateur
    _username = box.get('username', defaultValue: '');
    _password = box.get('password', defaultValue: '');
    _gapsId = box.get('gapsId', defaultValue: -1);
  }

  @override
  Future<bool> login() async {
    final String password = await encryptedPassword;
    //ajouter la connection + le localstorage
    _gapsId = await api.login(_username, password, decrypt: true);

    box.put('gapsId', gapsId);

    notifyListeners();
    return isConnected;
  }

  @override
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
