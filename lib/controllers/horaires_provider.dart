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
        defaultValue:
            Horaires(semestre: 2, annee: 2019, horaires: <HeureDeCours>[]));
    _horaires = hiveHoraires;
  }

  Future<bool> fetchHoraires() async {
    AuthController auth = GetIt.I.get<AuthController>();
    try {
      _horaires = await GetIt.I
          .get<ApiController>()
          .fetchHoraires(auth.username, auth.password, auth.gapsId);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

  List<HeureDeCours> getDailyClasses(DateTime day) {
    List<HeureDeCours> h = _horaires.horaires
        .where((h) => h.debut.weekday == day.weekday)
        .toList();
    h.sort((a, b) => a.debut.compareTo(b.debut));
    return h;
  }
}