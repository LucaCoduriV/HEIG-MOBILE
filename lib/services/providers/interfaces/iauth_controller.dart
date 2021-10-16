abstract class IAuthController {
  Future<String> get encryptedPassword;
  int get gapsId;
  bool get isConnected;
  String get password;
  String get username;

  set password(String password);
  set username(String username);

  Future<bool> login();
  Future<void> logout();
}
