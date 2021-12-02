import 'dart:developer';
import 'dart:isolate';

import 'package:awesome_notifications/awesome_notifications.dart';
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

Future<void> setupBackgroundTask() async {
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
      ),
    ],
  );
  await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
}

Future<void> backgroundMain() async {
  await setupBackgroundTask();

  final box = await Hive.openBox<dynamic>('heig');

  final username = box.get('username');
  final password = box.get('password');
  final gapsId = box.get('gapsId');

  //fetch old grades from storage
  final List<Bulletin> oldBulletins =
      (box.get('bulletins', defaultValue: Bulletin([])) as List<dynamic>)
          .cast<Bulletin>();
  // Fetch new grades from the server.
  final Bulletin newBulletin;
  try {
    newBulletin = await ApiController()
        .fetchNotes(username, password, gapsId, year: 2021);
  } catch (e) {
    print(e);
    return;
  }
  // Compare new grades with old grades.
  Bulletin oldBulletin;
  try {
    oldBulletin =
        oldBulletins.firstWhere((element) => element.year == newBulletin.year);
  } catch (e) {
    print(e);
    return;
  }

  final newGrades = Bulletin.getDiff(oldBulletin, newBulletin);
  // Update the old grades with the new grades.
  print(
      '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
  if (newGrades.isNotEmpty) {
    print('NOUVELLES NOTES !!!');
    final int index =
        oldBulletins.indexWhere((element) => element.year == newBulletin.year);
    oldBulletins[index] = newBulletin;
    box.put('bulletins', oldBulletins);

    final List<String> body =
        newGrades.map((e) => '${e.nom} : ${e.note}').toList();

    try {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10000,
          channelKey: 'grade_channel',
          title: 'Nouvelles notes disponibles !',
          body: body.join(' -'),
        ),
      );
    } catch (e) {
      print(e);
    }
  }
  // Notify the user of the change.
}
