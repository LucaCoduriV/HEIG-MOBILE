import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/api_controller.dart';
import 'package:heig_front/controllers/asymmetric_crypt.dart';
import 'package:heig_front/models/bulletin.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Cette classe permet de distribuer et mettre à jours les données concernant le bulletin
class BulletinProvider extends ChangeNotifier {
  late Bulletin _bulletin;
  var box = Hive.box('heig');

  BulletinProvider() {
    // Les données sont récupérée dans le localstorage
    Bulletin hiveBulletin = box.get('bulletin', defaultValue: Bulletin([]));
    _bulletin = hiveBulletin;
  }

  Bulletin get bulletin {
    return _bulletin;
  }

  /// Récupère le bulletin depuis l'API et informe les views que ça a été mis à jour
  Future<void> fetchBulletin(String username, String password) async {
    try {
      String publicKey = await GetIt.I<ApiController>().fetchPublicKey();

      AsymmetricCrypt rsa = new AsymmetricCrypt(publicKey);
      String encryptedPassword = rsa.encrypt(password);

      _bulletin = await GetIt.I<ApiController>()
          .fetchNotes(username, encryptedPassword, decrypt: true);
      box.put('bulletin', _bulletin);
    } catch (e) {
      return;
    }

    notifyListeners();
  }

  void emptyBulletin() {
    _bulletin = new Bulletin([]);
    notifyListeners();
  }
}
