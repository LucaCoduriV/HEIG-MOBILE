import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/api_controller.dart';
import 'package:heig_front/controllers/asymmetric_crypt.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Cette classe permet de gérer le nom et le mot de passe de l'utilisateur
class AuthController extends ChangeNotifier {
  late String _username;
  late String _password;
  late bool _isConnected;

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

  AuthController() {
    // Récupérer le nom et le mot de passe de l'utilisateur
    this._username = box.get('username', defaultValue: "");
    this._password = box.get('password', defaultValue: "");
    this._isConnected = box.get('isConnected', defaultValue: false);
  }

  Future<bool> login() async {
    String publicKey = await GetIt.I<ApiController>().fetchPublicKey();

    AsymmetricCrypt rsa = new AsymmetricCrypt(publicKey);
    String encryptedPassword = rsa.encrypt(_password);
    //ajouter la connection + le localstorage
    _isConnected = await GetIt.I<ApiController>()
        .login(_username, encryptedPassword, decrypt: true);
    box.put('isConnected', _isConnected);
    notifyListeners();
    return _isConnected;
  }

  Future<void> logout() async {
    // supprimer la connection + le localstorage
    box.delete('username');
    box.delete('password');
    box.delete('bulletin');
    _isConnected = false;
    box.put('isConnected', _isConnected);
    notifyListeners();
    return;
  }
}
