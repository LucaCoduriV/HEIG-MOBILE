import 'dart:developer';
import 'dart:isolate';

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

void printHello() {
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;
  print(
      "[$now] Hello, world! isolate=$isolateId function='$printHello' !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
}

Future<void> backgroundMain() async {
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

  final box = await Hive.openBox<dynamic>('heig');

  final username = box.get('username');
  final password = box.get('password');
  final gapsId = box.get('gapsId');

  //fetch old grades from storage
  final Bulletin oldBulletin = box.get('bulletin', defaultValue: Bulletin([]));
  // Fetch new grades from the server.
  final Bulletin newBulletin =
      await ApiController().fetchNotes(username, password, gapsId, year: 2021);
  // Compare new grades with old grades.
  final bool isNewGrades = compareBulletins(oldBulletin, newBulletin);
  // Update the old grades with the new grades.
  print(newBulletin.toString());
  if (isNewGrades) {
    print('NOUVELLES NOTES !!!');
  }
  // Notify the user of the change.
}

bool compareBulletins(Bulletin oldBulletin, Bulletin newBulletin) {
  int oldGradesCount = 0;
  int newGradesCount = 0;

  for (final Branche branche in oldBulletin.branches) {
    for (final Note _ in branche.cours) {
      oldGradesCount++;
    }
  }

  for (final Branche branche in newBulletin.branches) {
    for (final Note _ in branche.cours) {
      newGradesCount++;
    }
  }

  return newGradesCount > oldGradesCount;
}
