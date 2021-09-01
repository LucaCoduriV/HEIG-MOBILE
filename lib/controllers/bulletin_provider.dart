import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/api_controller.dart';
import 'package:heig_front/controllers/asymmetric_crypt.dart';
import 'package:heig_front/controllers/auth_controller.dart';
import 'package:heig_front/models/bulletin.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Cette classe permet de distribuer et mettre à jours les données concernant le bulletin
class BulletinProvider extends ChangeNotifier {
  late Bulletin _bulletin;
  late int _year;
  bool loading = false;
  var box = Hive.box('heig');

  BulletinProvider() {
    // Les données sont récupérée dans le localstorage
    Bulletin hiveBulletin = box.get('bulletin', defaultValue: Bulletin([]));
    int year = box.get('year', defaultValue: 2021);
    _bulletin = hiveBulletin;
    _year = year;
  }

  Bulletin get bulletin {
    return _bulletin;
  }

  int get year {
    return _year;
  }

  set year(value) {
    _year = value;
    box.put('year', year);
    notifyListeners();
  }

  /// Récupère le bulletin depuis l'API et informe les views que ça a été mis à jour
  Future<void> fetchBulletin() async {
    loading = true;
    notifyListeners();
    AuthController auth = GetIt.I.get<AuthController>();
    try {
      final password = await auth.encryptedPassword;

      _bulletin = await GetIt.I<ApiController>().fetchNotes(
          auth.username, password, auth.gapsId,
          year: _year, decrypt: true);
      box.put('bulletin', _bulletin);
    } catch (e) {
      return;
    }
    loading = false;
    notifyListeners();
  }

  void emptyBulletin() {
    _bulletin = new Bulletin([]);
    notifyListeners();
  }
}
