import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heig_front/controllers/api_controller.dart';
import 'package:heig_front/models/bulletin.dart';
import 'package:heig_front/models/horaires.dart';
import 'package:dotenv/dotenv.dart' show load, env;

void main() async {
  load();
  String username = env['USERNAME'].toString();
  String password = env['PASSWORD'].toString();
  String ip = env['SERVER_IP'].toString();
  String port = env['PORT'].toString();
  group("Notes", () {
    test("should be fetched", () async {
      final ApiController api = ApiController.withIp(ip, port);

      Bulletin bulletin = await api.fetchNotes(username, password);
      debugPrint(bulletin.toString());
      expect(bulletin.branches.length, greaterThan(0));
    });
  });

  group("Horaires", () {
    test("should be fetched", () async {
      final ApiController api = ApiController.withIp(ip, port);

      Horaires horaires = await api.fetchHoraires(username, password);
      debugPrint(horaires.toString());

      expect(horaires.horaires.length, greaterThan(0));
    });
  });
}
