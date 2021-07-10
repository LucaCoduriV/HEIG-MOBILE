import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
        dotenv.env["SERVER_IP"].toString(), dotenv.env["PORT"].toString());
  }

  Future<Horaires> fetchHoraires(String username, String password) async {
    Response res =
        await dio.get("/horaires?username=$username&password=$password");
    List<dynamic> json = res.data;
    List<HeureDeCours> horaires =
        json.map((e) => HeureDeCours.fromJson(e)).toList();
    return Horaires(semestre: 2, annee: 2020, horaires: horaires);
  }

  Future<Bulletin> fetchNotes(String username, String password) async {
    Response res =
        await dio.get("/notes?username=$username&password=$password");
    List<dynamic> json = res.data;
    List<Branche> notes = json.map((e) => Branche.fromJson(e)).toList();
    return Bulletin(notes);
  }

  Future<bool> login(String username, String password) async {
    try {
      await dio.get("/login?username=$username&password=$password");
    } catch (e) {
      return false;
    }
    return true;
  }
}
