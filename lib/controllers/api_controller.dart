import 'package:dio/dio.dart';

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
      connectTimeout: 5000,
      receiveTimeout: 3000,
      responseType: ResponseType.json,
    );

    dio = Dio(options);
  }

  Future<Response> fetchHoraires(String username, String password) {
    return dio.get("/horaires?username=$username&password=$password");
  }

  Future<Response> fetchNotes(String username, String password) {
    return dio.get("/notes?username=$username&password=$password");
  }
}
