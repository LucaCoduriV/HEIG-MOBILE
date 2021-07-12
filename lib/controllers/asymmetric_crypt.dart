import 'package:crypton/crypton.dart';

class AsymmetricCrypt {
  final String _key;
  RSAPublicKey? _publicKey;

  AsymmetricCrypt(this._key);

  String encrypt(String plain) {
    _publicKey ??= RSAPublicKey.fromPEM(this._key);
    return _publicKey!.encrypt(plain);
  }
}
