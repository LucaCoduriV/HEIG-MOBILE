import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:heig_front/models/branche.dart';
import 'package:heig_front/models/bulletin.dart';
import 'package:heig_front/models/heure_de_cours.dart';
import 'package:heig_front/models/horaires.dart';

class ApiController {
  late Dio dio;
  String serverIp = "localhost:8080";
  static ApiController _instance = ApiController._internal();

  factory ApiController() {
    return _instance;
  }

  ApiController._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: 'http://$serverIp',
      connectTimeout: 15000,
      receiveTimeout: 15000,
      responseType: ResponseType.json,
    );

    dio = Dio(options);
  }

  Future<Horaires> fetchHoraires(String username, String password) async {
    Response res =
        await dio.get("/horaires?username=$username&password=$password");
    List<HeureDeCours> horaires =
        res.data.map((e) => HeureDeCours.fromJson(e)).toList();
    return Horaires(semestre: 2, annee: 2020, horaires: horaires);
  }

  Future<Bulletin> fetchNotes(String username, String password) async {
    Response res =
        await dio.get("/notes?username=$username&password=$password");
    List<Branche> notes = res.data.map((e) => Branche.fromJson(e)).toList();
    return Bulletin(notes);
  }
}
