import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:heig_front/models/menu_jour.dart';
import 'package:heig_front/services/api/iapi.dart';

import '../../models/branche.dart';
import '../../models/bulletin.dart';
import '../../models/heure_de_cours.dart';
import '../../models/horaires.dart';
import '../../models/user.dart';
import '../../settings/env_settings.dart';

/// Cette classe permet de récupérer les données traitées depuis l'API
class ApiController implements IAPI {
  late final Dio _dio;
  late final String _serverIp;

  factory ApiController() {
    return ApiController._internal();
  }

  ApiController.withIp(String ip, String port) {
    _serverIp = '$ip:$port';

    final options = BaseOptions(
      baseUrl: 'http://$_serverIp',
      connectTimeout: 45000,
      receiveTimeout: 45000,
    );

    _dio = Dio(options);
  }

  factory ApiController._internal() {
    return ApiController.withIp(getApiIp(), getApiPort());
  }

  @override
  Future<Horaires> fetchHoraires(String username, String password, int gapsId,
      {bool decrypt = false}) async {
    await _hasInternetConnection();
    try {
      final res = await _dio.post<dynamic>('/horaires?decrypt=$decrypt',
          data: jsonEncode({
            'username': username,
            'password': password,
            'gapsId': gapsId,
          }));

      final Map<String, dynamic> json = res.data;
      final List<dynamic> horairesJson = json['VEVENT'];

      final List<HeureDeCours> horaires = horairesJson
          .where((element) =>
              (element as Map<String, dynamic>)['DTSTART;VALUE=DATE'] == null)
          .map((e) => HeureDeCours.fromJson(e))
          .toList()
          .cast<HeureDeCours>();
      final returnValue = Horaires(0, 2021);
      returnValue.horaires = horaires;
      return returnValue;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Erreur lors de la récupération des horaires');
    }
  }

  @override
  Future<Bulletin> fetchNotes(String username, String password, int gapsId,
      {int year = 2020, bool decrypt = false}) async {
    await _hasInternetConnection();
    try {
      final res = await _dio.post<dynamic>('/notes?decrypt=$decrypt',
          data: jsonEncode({
            'username': username,
            'password': password,
            'gapsId': gapsId,
            'year': year,
          }));
      final List<dynamic> json = res.data;
      final List<Branche> notes = json.map((e) => Branche.fromJson(e)).toList();
      return Bulletin(notes, year: year);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Erreur lors de la récupération des notes');
    }
  }

  @override
  Future<List<MenuJour>> fetchMenuSemaine() async {
    await _hasInternetConnection();
    try {
      final res = await _dio.get<dynamic>('/menus');
      final Map<String, dynamic> json = res.data;
      final List<MenuJour> menuSemaine =
          json.entries.map((e) => MenuJour.fromJson(e)).toList();
      return menuSemaine;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Erreur lors de la récupération des menus');
    }
  }

  @override
  Future<String> fetchPublicKey() async {
    await _hasInternetConnection();
    try {
      return (await _dio.get<dynamic>('/public_key')).data['publicKey'];
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Erreur lors de la récupération de la clé public');
    }
  }

  @override
  Future<User> fetchUser(String username, String password, int gapsId,
      {bool decrypt = false}) async {
    await _hasInternetConnection();
    try {
      final response = await _dio.post<dynamic>(
        '/user?decrypt=$decrypt',
        data: jsonEncode({
          'username': username,
          'password': password,
          'gapsId': gapsId,
        }),
      );
      final Map<String, dynamic> json = response.data;

      return User.fromJson(json);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(
          "Erreur lors de la récupération des informations de l'utilisateur");
    }
  }

  @override
  Future<int> login(String username, String password,
      {bool decrypt = false}) async {
    await _hasInternetConnection();
    try {
      return (await _dio.post<dynamic>(
        '/login?decrypt=$decrypt',
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

  Future<void> _hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw Exception('No internet connection');
    }
  }
}
