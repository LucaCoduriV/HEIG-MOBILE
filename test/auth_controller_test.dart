import 'package:dotenv/dotenv.dart' show load, env;
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/services/api.dart';
import 'package:heig_front/services/auth.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  load();
  final String username = env['USERNAME'].toString();
  final String password = env['PASSWORD'].toString();
  final String ip = env['SERVER_IP_DEV'].toString();
  final String port = env['PORT_DEV'].toString();
  await Hive.initFlutter();
  await Hive.openBox<dynamic>('heig');
  GetIt.I.registerSingleton<ApiController>(ApiController.withIp(ip, port));
  GetIt.I.registerSingleton<AuthController>(AuthController());
  group('Login', () {
    test('should return true', () async {
      GetIt.I<AuthController>().username = username;
      GetIt.I<AuthController>().password = password;

      final bool login = await GetIt.I<AuthController>().login();

      expect(login, true);
    });

    test('should return false', () async {
      GetIt.I<AuthController>().username = 'wrong';
      GetIt.I<AuthController>().password = 'wrong';

      final bool login = await GetIt.I<AuthController>().login();

      expect(login, false);
    });
  });
}
