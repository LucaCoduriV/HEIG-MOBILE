import 'package:crypton/crypton.dart';

// Permet de gérer le chiffrement.
class AsymmetricCrypt {
  final String _key;
  RSAPublicKey? _publicKey;

  AsymmetricCrypt(this._key);

  String encrypt(String plain) {
    _publicKey ??= RSAPublicKey.fromPEM(_key);
    return _publicKey!.encrypt(plain);
  }
}
