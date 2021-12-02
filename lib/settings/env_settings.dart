import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Récupère l'ip dans le fichier .env selon le mode de build.

String getApiIp() {
  if (kReleaseMode) {
    return dotenv.env['SERVER_IP_PROD'] as String;
  } else {
    return dotenv.env['SERVER_IP_DEV'] as String;
  }
}

/// Récupère le port dans le fichier .env selon le mode de build.
String getApiPort() {
  if (kReleaseMode) {
    return dotenv.env['PORT_PROD'] as String;
  } else {
    return dotenv.env['PORT_DEV'] as String;
  }
}

Duration backgroundTaskDuration() {
  if (kReleaseMode) {
    return const Duration(minutes: 10);
  } else {
    return const Duration(seconds: 30);
  }
}
