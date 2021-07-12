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
  String ip = env['SERVER_IP_DEV'].toString();
  String port = env['PORT_DEV'].toString();

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

  group("Login", () {
    test("should return true", () async {
      final ApiController api = ApiController.withIp(ip, port);

      bool connected = await api.login(username, password);

      expect(connected, true);
    });

    test("should return false", () async {
      final ApiController api = ApiController.withIp(ip, port);

      bool connected = await api.login("wrong", "wrong");

      expect(connected, false);
    });
  });
}
