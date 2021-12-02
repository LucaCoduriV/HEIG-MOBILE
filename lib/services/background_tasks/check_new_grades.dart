import 'dart:io' show Platform;

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:heig_front/models/todo.dart';
import 'package:heig_front/services/api/api.dart';
import 'package:heig_front/services/api/response_types/branche.dart';
import 'package:heig_front/services/api/response_types/bulletin.dart';
import 'package:heig_front/services/api/response_types/heure_de_cours.dart';
import 'package:heig_front/services/api/response_types/horaires.dart';
import 'package:heig_front/services/api/response_types/notes.dart';
import 'package:heig_front/services/api/response_types/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../asymmetric_crypt.dart';

const int backgroundTaskId = 0;

Future<void> setupBackgroundTask() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) {
    return;
  }

  await dotenv.load();
  if (!Hive.isAdapterRegistered(BulletinAdapter().typeId) &&
      !Hive.isAdapterRegistered(BrancheAdapter().typeId) &&
      !Hive.isAdapterRegistered(HeureDeCoursAdapter().typeId) &&
      !Hive.isAdapterRegistered(HorairesAdapter().typeId) &&
      !Hive.isAdapterRegistered(NoteAdapter().typeId) &&
      !Hive.isAdapterRegistered(TodoAdapter().typeId) &&
      !Hive.isAdapterRegistered(UserAdapter().typeId)) {
    await Hive.initFlutter();
    Hive.registerAdapter(BulletinAdapter());
    Hive.registerAdapter(BrancheAdapter());
    Hive.registerAdapter(HeureDeCoursAdapter());
    Hive.registerAdapter(HorairesAdapter());
    Hive.registerAdapter(NoteAdapter());
    Hive.registerAdapter(TodoAdapter());
    Hive.registerAdapter(UserAdapter());
  }

  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'grade_channel',
        channelName: 'Grade',
        channelDescription: 'Notification channel for Grades',
        defaultColor: Colors.red,
        ledColor: Colors.white,
        enableVibration: true,
      ),
    ],
  );
  await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      return;
    }
  });
}

void startBackgroundTask(Duration duration) {
  if (Platform.isAndroid) {
    AndroidAlarmManager.periodic(
      duration,
      backgroundTaskId,
      backgroundMain,
      rescheduleOnReboot: true,
      exact: true,
      allowWhileIdle: true,
      wakeup: true,
    );
  }
}

void stopBackgroundTask() {
  if (Platform.isAndroid) {
    AndroidAlarmManager.cancel(backgroundTaskId);
  }
}

Future<void> backgroundMain() async {
  await setupBackgroundTask();

  final box = await Hive.openBox<dynamic>('heig');

  final username = box.get('username');
  final password = box.get('password');
  final gapsId = box.get('gapsId');

  if (username == '' || password == '' || gapsId == -1) {
    // don't even try to fetch data !
    return;
  }

  //fetch old grades from storages
  final List<Bulletin> oldBulletins =
      (box.get('bulletins', defaultValue: Bulletin([])) as List<dynamic>)
          .cast<Bulletin>();
  // Fetch new grades from the server.
  final Bulletin newBulletin;
  try {
    final key = await ApiController().fetchPublicKey();

    final encryptedPassword = AsymmetricCrypt(key).encrypt(password);
    newBulletin = await ApiController().fetchNotes(
      username,
      encryptedPassword,
      gapsId,
      year: 2021,
      decrypt: true,
    );
  } catch (e) {
    debugPrint(e.toString());
    return;
  }
  // Compare new grades with old grades.
  Bulletin oldBulletin;
  try {
    oldBulletin =
        oldBulletins.firstWhere((element) => element.year == newBulletin.year);
  } catch (e) {
    oldBulletin = Bulletin([], year: 2021);
  }

  final newGrades = Bulletin.getDiff(oldBulletin, newBulletin);
  // Update the old grades with the new grades.
  if (newGrades.isNotEmpty) {
    final int index =
        oldBulletins.indexWhere((element) => element.year == newBulletin.year);
    oldBulletins[index] = newBulletin;
    box.put('bulletins', oldBulletins);

    final List<String> body =
        newGrades.map((e) => '${e.nom} : ${e.note}').toList();

    try {
      // Notify the user of the change.
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10000,
          channelKey: 'grade_channel',
          title: 'Nouvelle(s) note(s) disponibles !',
          body: body.join(' - '),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
