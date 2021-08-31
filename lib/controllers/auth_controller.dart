import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/api_controller.dart';
import 'package:heig_front/controllers/asymmetric_crypt.dart';
import 'package:heig_front/controllers/bulletin_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Cette classe permet de gérer le nom et le mot de passe de l'utilisateur
class AuthController extends ChangeNotifier {
  late String _username;
  late String _password;
  late int _gapsId;

  var box = Hive.box('heig');

  bool get isConnected => gapsId != -1;

  set username(String username) {
    var box = Hive.box('heig');
    _username = username;
    box.put('username', username);
  }

  set password(String password) {
    _password = password;
    var box = Hive.box('heig');
    box.put('password', password);
  }

  String get username => _username;
  String get password => _password;
  int get gapsId => _gapsId;

  AuthController() {
    // Récupérer le nom et le mot de passe de l'utilisateur
    this._username = box.get('username', defaultValue: "");
    this._password = box.get('password', defaultValue: "");
    this._gapsId = box.get('gapsId', defaultValue: -1);
  }

  Future<bool> login() async {
    try {
      String publicKey = await GetIt.I<ApiController>().fetchPublicKey();

      AsymmetricCrypt rsa = new AsymmetricCrypt(publicKey);
      String encryptedPassword = rsa.encrypt(_password);
      //ajouter la connection + le localstorage
      _gapsId = await GetIt.I<ApiController>()
          .login(_username, encryptedPassword, decrypt: true);

      box.put('gapsId', gapsId);

      notifyListeners();
      return isConnected;
    } catch (e) {
      _gapsId = -1;
      box.put('gapsId', -1);

      notifyListeners();
      return isConnected;
    }
  }

  Future<void> logout() async {
    // supprimer la connection + le localstorage
    box.delete('username');
    box.delete('password');
    box.delete('bulletin');
    box.delete('user');
    box.delete('horaires');
    box.put('gapsId', -1);
    _gapsId = -1;
    this._password = "";
    GetIt.I<BulletinProvider>().emptyBulletin();
    notifyListeners();
    return;
  }
}
