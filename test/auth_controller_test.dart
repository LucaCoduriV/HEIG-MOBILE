import 'package:dotenv/dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/services/api/api.dart';
import 'package:heig_front/services/auth/auth.dart';
import 'package:heig_front/utils/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  final env = DotEnv(includePlatformEnvironment: true)..load();
  final String username = env['USERNAME'].toString();
  final String password = env['PASSWORD'].toString();
  final String ip = env['SERVER_IP_DEV'].toString();
  final String port = env['PORT_DEV'].toString();
  await Hive.initFlutter();
  await Hive.openBox<dynamic>(BOX_HEIG);
  GetIt.I.registerSingleton<ApiController>(ApiController.withIp(ip, port));
  GetIt.I.registerSingleton<Auth>(Auth());
  group('Login', () {
    test('should return true', () async {
      GetIt.I<Auth>().username = username;
      GetIt.I<Auth>().password = password;

      final bool login = await GetIt.I<Auth>().login();

      expect(login, true);
    });

    test('should return false', () async {
      GetIt.I<Auth>().username = 'wrong';
      GetIt.I<Auth>().password = 'wrong';

      final bool login = await GetIt.I<Auth>().login();

      expect(login, false);
    });
  });
}
