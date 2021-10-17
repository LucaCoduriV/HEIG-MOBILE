import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/services/auth/iauth.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../api/iapi.dart';
import '../api/response_types/bulletin.dart';

/// Cette classe permet de distribuer et mettre à jours les données concernant le bulletin
class BulletinProvider extends ChangeNotifier {
  late Bulletin _bulletin;
  late int _year;
  bool loading = false;
  final box = Hive.box('heig');
  final api = GetIt.I.get<IAPI>();
  final auth = GetIt.I.get<IAuth>();

  BulletinProvider() {
    // Les données sont récupérée dans le localstorage
    final Bulletin hiveBulletin =
        box.get('bulletin', defaultValue: Bulletin([]));
    final int year = box.get('year', defaultValue: DateTime.now().year);
    _bulletin = hiveBulletin;
    _year = year;
  }

  Bulletin get bulletin {
    return _bulletin;
  }

  int get year {
    return _year;
  }

  set year(int value) {
    _year = value;
    box.put('year', year);
    notifyListeners();
  }

  /// Récupère le bulletin depuis l'API et informe les views que ça a été mis à jour
  Future<void> fetchBulletin() async {
    loading = true;
    notifyListeners();
    try {
      final password = await auth.encryptedPassword;

      _bulletin = await api.fetchNotes(auth.username, password, auth.gapsId,
          year: _year, decrypt: true);
      box.put('bulletin', _bulletin);
    } catch (e) {
      return;
    }
    loading = false;
    notifyListeners();
  }

  void emptyBulletin() {
    _bulletin = Bulletin([]);
    notifyListeners();
  }
}
