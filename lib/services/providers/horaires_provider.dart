import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/heure_de_cours.dart';
import '../../models/horaires.dart';
import '../api_controller.dart';
import '../auth_controller.dart';

/// Cette classe permet de distribuer et mettre à jours les données concernant les horaires.
class HorairesProvider extends ChangeNotifier {
  late Horaires _horaires;
  final box = Hive.box('heig');

  HorairesProvider() {
    final Horaires hiveHoraires = box.get('horaires',
        defaultValue: Horaires(0, 2021, <HeureDeCours>[], ''));
    _horaires = hiveHoraires;
  }

  Horaires get horaires => _horaires;

  Future<bool> fetchHoraires() async {
    final AuthController auth = GetIt.I.get<AuthController>();
    try {
      final password = await GetIt.I<AuthController>().encryptedPassword;

      // Annuler toutes les notifications avant de récupérer les horaires
      for (final heureCours in _horaires.horairesRRule) {
        await heureCours.cancelNotification();
      }

      _horaires = await GetIt.I
          .get<ApiController>()
          .fetchHoraires(auth.username, password, auth.gapsId, decrypt: true);

      box.put('horaires', _horaires);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

  List<HeureDeCours> getDailyClasses(DateTime day) {
    final List<HeureDeCours> h = _horaires.horairesRRule
        .where((h) =>
            h.debut.day == day.day &&
            h.debut.month == day.month &&
            h.debut.year == day.year)
        .toList();
    h.sort((a, b) => a.debut.compareTo(b.debut));
    return h;
  }
}
