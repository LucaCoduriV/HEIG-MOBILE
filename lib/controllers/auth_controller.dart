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
  late bool _isConnected;
  late int _gapsId;

  var box = Hive.box('heig');

  get isConnected => _isConnected;

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
    this._isConnected = box.get('isConnected', defaultValue: false);
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

      _isConnected = _gapsId != -1;
      box.put('gapsId', gapsId);
      box.put('isConnected', _isConnected);

      notifyListeners();
      return _isConnected;
    } catch (e) {
      _isConnected = false;

      box.put('isConnected', _isConnected);
      box.put('gapsId', -1);

      notifyListeners();
      return _isConnected;
    }
  }

  Future<void> logout() async {
    // supprimer la connection + le localstorage
    box.delete('username');
    box.delete('password');
    box.delete('bulletin');
    _isConnected = false;
    box.put('isConnected', _isConnected);
    this._password = "";
    GetIt.I<BulletinProvider>().emptyBulletin();
    notifyListeners();
    return;
  }
}
