import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:heig_front/controllers/env_controller.dart';
import 'package:heig_front/models/branche.dart';
import 'package:heig_front/models/bulletin.dart';
import 'package:heig_front/models/heure_de_cours.dart';
import 'package:heig_front/models/horaires.dart';
import 'package:heig_front/models/user.dart';

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
      connectTimeout: 45000,
      receiveTimeout: 45000,
      responseType: ResponseType.json,
    );

    dio = Dio(options);
  }

  factory ApiController._internal() {
    return ApiController.withIp(
        EnvController.getApiIp(), EnvController.getApiPort());
  }

  Future<Horaires> fetchHoraires(String username, String password, int gapsId,
      {bool decrypt: false}) async {
    try {
      Response res = await dio.post("/horaires?decrypt=$decrypt",
          data: jsonEncode({
            'username': username,
            'password': password,
            'gapsId': gapsId,
          }));

      Map<String, dynamic> json = res.data;
      List<dynamic> horairesJson = json["VEVENT"];
      List<HeureDeCours> horaires = horairesJson
          .map((e) => HeureDeCours.fromJson(e))
          .toList()
          .cast<HeureDeCours>();
      return Horaires(semestre: 2, annee: 2020, horaires: horaires);
    } catch (e) {
      debugPrint(e.toString());
      throw new Exception("Erreur lors de la récupération des horaires");
    }
  }

  Future<Bulletin> fetchNotes(String username, String password, int gapsId,
      {int year = 2020, bool decrypt: false}) async {
    try {
      Response res = await dio.post("/notes?decrypt=$decrypt",
          data: jsonEncode({
            'username': username,
            'password': password,
            'gapsId': gapsId,
            'year': year,
          }));
      List<dynamic> json = res.data;
      List<Branche> notes = json.map((e) => Branche.fromJson(e)).toList();
      return Bulletin(notes, year: year);
    } catch (e) {
      debugPrint(e.toString());
      throw new Exception("Erreur lors de la récupération des notes");
    }
  }

  Future<int> login(String username, String password,
      {bool decrypt: false}) async {
    try {
      return (await dio.post(
        "/login?decrypt=$decrypt",
        data: jsonEncode({
          'username': username,
          'password': password,
        }),
      ))
          .data['id'];
    } catch (e) {
      debugPrint(e.toString());
      return -1;
    }
  }

  Future<User> fetchUser(String username, String password, int gapsId,
      {bool decrypt: false}) async {
    try {
      Response response = await dio.post(
        "/user?decrypt=$decrypt",
        data: jsonEncode({
          'username': username,
          'password': password,
          'gapsId': gapsId,
        }),
      );
      Map<String, dynamic> json = response.data;

      return User.fromJson(json);
    } catch (e) {
      debugPrint(e.toString());
      throw new Exception(
          "Erreur lors de la récupération des informations de l'utilisateur");
    }
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
