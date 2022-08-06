import 'package:flutter/cupertino.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/services/api/iapi.dart';
import 'package:heig_front/services/auth/iauth.dart';
import 'package:heig_front/utils/constants.dart';
import 'package:heig_front/utils/notification.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/heure_de_cours.dart';
import '../../models/horaires.dart';

/// Cette classe permet de distribuer et mettre à jours les données concernant les horaires.
class HorairesProvider extends ChangeNotifier {
  late Horaires _horaires;
  final _box = Hive.box(BOX_HEIG);
  final _api = GetIt.I.get<IAPI>();
  static final int NB_SCHEDULED_NOTIFICATION = 64;

  HorairesProvider() {
    final Horaires hiveHoraires = _box.get('horaires',
        defaultValue: Horaires(
          0,
          2021,
          horaires: <HeureDeCours>[],
        ));
    _horaires = hiveHoraires;
  }

  Horaires get horaires => _horaires;

  Future<void> cancelNotifications() async {
    //cancelMultipleNotifications(_horaires.horaires);
    cancelMultipleNotificationsWithChannelKey('horaires_channel');
  }

  void registerNotifications() {
    final notifiables = _horaires.horaires
        .where((heureCours) => DateTime.now().isBefore(heureCours.debut))
        .toList();

    registerMultipleNotifications(notifiables.getRange(
        0,
        notifiables.length > NB_SCHEDULED_NOTIFICATION
            ? NB_SCHEDULED_NOTIFICATION
            : notifiables.length));
  }

  Future<bool> fetch() async {
    final IAuth auth = GetIt.I.get<IAuth>();
    try {
      final password = await GetIt.I<IAuth>().encryptedPassword;

      // Annuler toutes les notifications avant de récupérer les horaires
      await cancelNotifications();

      _horaires = await _api.fetchHoraires(auth.username, password, auth.gapsId,
          decrypt: true);
      _horaires.horaires.sort((a, b) => a.debut.compareTo(b.debut));
      registerNotifications();

      _box.put('horaires', _horaires);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint(e.toString());
      AlertController.show(
        'Erreur !',
        'Une erreur est survenue lors de la récupération des horaires.',
        TypeAlert.error,
      );
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
