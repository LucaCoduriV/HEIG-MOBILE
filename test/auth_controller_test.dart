import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/api_controller.dart';
import 'package:dotenv/dotenv.dart' show load, env;
import 'package:heig_front/controllers/auth_controller.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  load();
  String username = env['USERNAME'].toString();
  String password = env['PASSWORD'].toString();
  String ip = env['SERVER_IP_DEV'].toString();
  String port = env['PORT_DEV'].toString();
  await Hive.initFlutter();
  await Hive.openBox('heig');
  GetIt.I.registerSingleton<ApiController>(ApiController.withIp(ip, port));
  GetIt.I.registerSingleton<AuthController>(AuthController());
  group("Login", () {
    test("should return true", () async {
      GetIt.I<AuthController>().username = username;
      GetIt.I<AuthController>().password = password;

      bool login = await GetIt.I<AuthController>().login();

      expect(login, true);
    });

    test("should return false", () async {
      GetIt.I<AuthController>().username = "wrong";
      GetIt.I<AuthController>().password = "wrong";

      bool login = await GetIt.I<AuthController>().login();

      expect(login, false);
    });
  });
}
