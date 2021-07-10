import 'package:hive_flutter/hive_flutter.dart';

/// Cette classe permet de gérer le nom et le mot de passe de l'utilisateur
class AuthController {
  String username = "";
  String password = "";
  bool isConnected = false;
  bool isLoading = false;

  AuthController() {
    // Récupérer le nom et le mot de passe de l'utilisateur
    var box = Hive.box('heig');
    String username = box.get('username', defaultValue: "");
    String password = box.get('password', defaultValue: "");
  }

  Future<bool> login() async {
    //ajouter la connection + le localstorage
    isConnected = true;
    return true;
  }

  Future<void> logout() async {
    // supprimer la connection + le localstorage
    isConnected = false;
    return;
  }
}
