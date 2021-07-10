import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/api_controller.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Cette classe permet de gérer le nom et le mot de passe de l'utilisateur
class AuthController extends ChangeNotifier {
  late String _username;
  late String _password;
  bool isConnected = false;

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

  AuthController() {
    // Récupérer le nom et le mot de passe de l'utilisateur
    var box = Hive.box('heig');
    this._username = box.get('username', defaultValue: "");
    this._password = box.get('password', defaultValue: "");
  }

  Future<bool> login() async {
    //ajouter la connection + le localstorage
    isConnected = await GetIt.I<ApiController>().login(_username, _password);
    notifyListeners();
    return isConnected;
  }

  Future<void> logout() async {
    // supprimer la connection + le localstorage
    var box = Hive.box('heig');
    box.delete('username');
    box.delete('password');
    isConnected = false;
    notifyListeners();
    return;
  }
}
