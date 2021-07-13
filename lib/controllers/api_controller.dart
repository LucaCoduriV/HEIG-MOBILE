import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:heig_front/controllers/env_controller.dart';
import 'package:heig_front/models/branche.dart';
import 'package:heig_front/models/bulletin.dart';
import 'package:heig_front/models/heure_de_cours.dart';
import 'package:heig_front/models/horaires.dart';

/// Cette classe permet de récupérer les données traitées depuis l'API
class ApiController {
  late Dio dio;
  late String serverIp;

  factory ApiController() {
    return ApiController._internal();
  }

  ApiController.withIp(String ip, String port) {
    serverIp = "$ip:$port";

    BaseOptions options = BaseOptions(
      baseUrl: 'http://$serverIp',
      connectTimeout: 15000,
      receiveTimeout: 15000,
      responseType: ResponseType.json,
    );

    dio = Dio(options);
  }

  factory ApiController._internal() {
    return ApiController.withIp(
        EnvController.getApiIp(), EnvController.getApiPort());
  }

  Future<Horaires> fetchHoraires(String username, String password,
      {bool decrypt: false}) async {
    try {
      Response res = await dio.post("/horaires?decrypt=$decrypt",
          data: jsonEncode({
            'username': username,
            'password': password,
          }));

      List<dynamic> json = res.data;
      List<HeureDeCours> horaires =
          json.map((e) => HeureDeCours.fromJson(e)).toList();
      return Horaires(semestre: 2, annee: 2020, horaires: horaires);
    } catch (e) {
      debugPrint(e.toString());
      throw new Exception("Erreur lors de la récupération des horaires");
    }
  }

  Future<Bulletin> fetchNotes(String username, String password,
      {bool decrypt: false}) async {
    try {
      Response res = await dio.post("/notes?decrypt=$decrypt",
          data: jsonEncode({
            'username': username,
            'password': password,
          }));
      List<dynamic> json = res.data;
      List<Branche> notes = json.map((e) => Branche.fromJson(e)).toList();
      return Bulletin(notes);
    } catch (e) {
      debugPrint(e.toString());
      throw new Exception("Erreur lors de la récupération des notes");
    }
  }

  Future<bool> login(String username, String password,
      {bool decrypt: false}) async {
    try {
      await dio.post(
        "/login?decrypt=$decrypt",
        data: jsonEncode({
          'username': username,
          'password': password,
        }),
      );
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
    return true;
  }

  Future<String> fetchPublicKey() async {
    try {
      return (await dio.get("/public_key")).data['publicKey'] as String;
    } catch (e) {
      debugPrint(e.toString());
      throw new Exception("Erreur lors de la récupération de la clé public");
    }
  }
}
