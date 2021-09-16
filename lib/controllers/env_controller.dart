import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvController {
  static String getApiIp() {
    if (foundation.kReleaseMode) {
      return dotenv.env['SERVER_IP_PROD'] as String;
    } else {
      return dotenv.env['SERVER_IP_DEV'] as String;
    }
  }

  static String getApiPort() {
    if (foundation.kReleaseMode) {
      return dotenv.env['PORT_PROD'] as String;
    } else {
      return dotenv.env['PORT_DEV'] as String;
    }
  }
}
