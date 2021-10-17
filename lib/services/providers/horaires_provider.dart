import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/services/api/iapi.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../api/response_types/heure_de_cours.dart';
import '../api/response_types/horaires.dart';
import '../auth/auth.dart';

/// Cette classe permet de distribuer et mettre à jours les données concernant les horaires.
class HorairesProvider extends ChangeNotifier {
  late Horaires _horaires;
  final box = Hive.box('heig');
  final api = GetIt.I.get<IAPI>();

  HorairesProvider() {
    final Horaires hiveHoraires = box.get('horaires',
        defaultValue: Horaires(
          0,
          2021,
          horaires: <HeureDeCours>[],
        ));
    _horaires = hiveHoraires;
  }

  Horaires get horaires => _horaires;

  Future<void> cancelNotifications() async {
    for (final heureCours in _horaires.horaires) {
      await heureCours.cancelNotification();
    }
  }

  void registerNotifications() {
    final now = DateTime.now();
    for (final heureCours in _horaires.horaires) {
      if (now.isAfter(heureCours.debut) ||
          now.add(const Duration(days: 30)).isBefore(heureCours.debut)) {
        continue;
      }
      heureCours.scheduleNotification();
    }
  }

  Future<bool> fetchHoraires() async {
    final Auth auth = GetIt.I.get<Auth>();
    try {
      final password = await GetIt.I<Auth>().encryptedPassword;

      // Annuler toutes les notifications avant de récupérer les horaires
      await cancelNotifications();

      _horaires = await api.fetchHoraires(auth.username, password, auth.gapsId,
          decrypt: true);

      registerNotifications();

      box.put('horaires', _horaires);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

  List<HeureDeCours> getDailyClasses(DateTime day) {
    final List<HeureDeCours> h = _horaires.horaires
        .where((h) =>
            h.debut.day == day.day &&
            h.debut.month == day.month &&
            h.debut.year == day.year)
        .toList();
    h.sort((a, b) => a.debut.compareTo(b.debut));
    return h;
  }
}
