import 'package:flutter/cupertino.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/services/auth/iauth.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/bulletin.dart';
import '../api/iapi.dart';

/// Cette classe permet de distribuer et mettre à jours les données concernant le bulletin
class BulletinProvider extends ChangeNotifier {
  late List<Bulletin> _bulletins;
  late int _year;
  int loading = 0;
  final box = Hive.box('heig');
  final api = GetIt.I.get<IAPI>();
  final auth = GetIt.I.get<IAuth>();

  BulletinProvider() {
    // Les données sont récupérée dans le localstorage
    final List<Bulletin> hiveBulletins =
        (box.get('bulletins', defaultValue: <Bulletin>[]) as List<dynamic>)
            .cast<Bulletin>();
    final int year = box.get('year', defaultValue: DateTime.now().year);

    _year = year;
    _bulletins = hiveBulletins;
  }

  /// Permet de récupérer le bulletin de l'année [year]
  Bulletin get bulletin {
    return _bulletins.firstWhere((bulletin) => bulletin.year == _year,
        orElse: () => Bulletin([]));
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
  Future<void> fetch() async {
    loading++;
    notifyListeners();
    final year = _year;
    try {
      final password = await auth.encryptedPassword;

      final bulletin = await api.fetchNotes(
          auth.username, password, auth.gapsId,
          year: _year, decrypt: true);

      _bulletins.removeWhere((element) => element.year == year);
      _bulletins.add(bulletin);
      box.put('bulletins', _bulletins);
    } catch (e) {
      loading--;
      AlertController.show(
        'Erreur !',
        'Une erreur est survenue lors de la récupération des notes.',
        TypeAlert.error,
      );
      return;
    }
    loading--;
    notifyListeners();
  }

  void emptyBulletins() {
    _bulletins.clear();
    notifyListeners();
  }
}
