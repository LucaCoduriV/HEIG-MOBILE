import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/api_controller.dart';
import 'package:heig_front/controllers/auth_controller.dart';
import 'package:heig_front/models/heure_de_cours.dart';
import 'package:heig_front/models/horaires.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HorairesProvider extends ChangeNotifier {
  late Horaires _horaires;
  var box = Hive.box('heig');
  Horaires get horaires => _horaires;

  HorairesProvider() {
    Horaires hiveHoraires = box.get('horaires',
        defaultValue: Horaires(0, 2021, <HeureDeCours>[], ""));
    _horaires = hiveHoraires;
  }

  Future<bool> fetchHoraires() async {
    AuthController auth = GetIt.I.get<AuthController>();
    try {
      final publicKey = await GetIt.I<AuthController>().publicKey;
      String encryptedPassword = publicKey.encrypt(auth.password);

      _horaires = await GetIt.I.get<ApiController>().fetchHoraires(
          auth.username, encryptedPassword, auth.gapsId,
          decrypt: true);
      box.put('horaires', _horaires);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

  List<HeureDeCours> getDailyClasses(DateTime day) {
    List<HeureDeCours> h = _horaires.horairesRRule
        .where((h) =>
            h.debut.day == day.day &&
            h.debut.month == day.month &&
            h.debut.year == day.year)
        .toList();
    h.sort((a, b) => a.debut.compareTo(b.debut));
    return h;
  }
}
