import 'package:dotenv/dotenv.dart' show load, env;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heig_front/models/bulletin.dart';
import 'package:heig_front/models/horaires.dart';
import 'package:heig_front/services/api/api.dart';

Future<void> main() async {
  load();
  final String username = env['USERNAME'].toString();
  final String password = env['PASSWORD'].toString();
  final int gapsId = int.parse(env['GAPS_ID'].toString());
  final String ip = env['SERVER_IP_DEV'].toString();
  final String port = env['PORT_DEV'].toString();

  group('Login', () {
    test('should be greater than -1', () async {
      final ApiController api = ApiController.withIp(ip, port);

      final int id = await api.login(username, password);

      expect(id, greaterThan(-1));
    });

    test('should return -1', () async {
      final ApiController api = ApiController.withIp(ip, port);

      final int id = await api.login('wrong', 'wrong');

      expect(id, -1);
    });
  });

  group('Notes', () {
    test('should be fetched', () async {
      final ApiController api = ApiController.withIp(ip, port);

      final Bulletin bulletin =
          await api.fetchNotes(username, password, gapsId);
      debugPrint(bulletin.toString());
      expect(bulletin.branches.length, greaterThan(0));
    });
  });

  group('Horaires', () {
    test('should be fetched', () async {
      final ApiController api = ApiController.withIp(ip, port);

      final Horaires horaires =
          await api.fetchHoraires(username, password, 16746);
      debugPrint(horaires.toString());

      expect(horaires.horaires.length, greaterThan(0));
    });
  });
}
