import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Récupère les données dans le fichier .env selon le mode de build.

String getApiIp() {
  if (foundation.kReleaseMode) {
    return dotenv.env['SERVER_IP_PROD'] as String;
  } else {
    return dotenv.env['SERVER_IP_DEV'] as String;
  }
}

String getApiPort() {
  if (foundation.kReleaseMode) {
    return dotenv.env['PORT_PROD'] as String;
  } else {
    return dotenv.env['PORT_DEV'] as String;
  }
}
