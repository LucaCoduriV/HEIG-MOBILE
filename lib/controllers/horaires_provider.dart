import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/heure_de_cours.dart';
import '../models/horaires.dart';
import 'api_controller.dart';
import 'auth_controller.dart';
import 'notifications_manager.dart';

/// Cette classe permet de distribuer et mettre à jours les données concernant les horaires.
class HorairesProvider extends ChangeNotifier {
  late Horaires _horaires;
  var box = Hive.box('heig');

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

      _horaires = await GetIt.I
          .get<ApiController>()
          .fetchHoraires(auth.username, password, auth.gapsId, decrypt: true);

      box.put('horaires', _horaires);

      // notificationIds.forEach((element) {
      //   AwesomeNotifications().cancel(element);
      // });
      // data.forEach((element) {
      //   if (element.debut.isAfter(DateTime.now())) {
      //     GetIt.I.get<NotificationsManager>().registerNotificationHoraire(
      //           element.nom,
      //           element.salle,
      //           element.debut.subtract(const Duration(hours: 1)),
      //         );
      //   }
      // });

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

  void setNotification() {
    _horaires.horairesRRule.forEach((element) {
      if (element.debut.isAfter(DateTime.now())) {
        GetIt.I.get<NotificationsManager>().registerNotificationHoraire(
              element.nom,
              element.salle,
              element.debut.subtract(const Duration(hours: 1)),
            );
      }
    });
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
