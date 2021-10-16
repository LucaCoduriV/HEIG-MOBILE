import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:heig_front/models/menu_jour.dart';
import 'package:heig_front/services/providers/interfaces/iapi.dart';

import '../../settings/env_settings.dart';
import 'response_types/branche.dart';
import 'response_types/bulletin.dart';
import 'response_types/heure_de_cours.dart';
import 'response_types/horaires.dart';
import 'response_types/user.dart';

/// Cette classe permet de récupérer les données traitées depuis l'API
class ApiController implements IAPI {
  late Dio dio;
  late String serverIp;

  factory ApiController() {
    return ApiController._internal();
  }

  ApiController.withIp(String ip, String port) {
    serverIp = '$ip:$port';

    final options = BaseOptions(
      baseUrl: 'http://$serverIp',
      connectTimeout: 45000,
      receiveTimeout: 45000,
    );

    dio = Dio(options);
  }

  factory ApiController._internal() {
    return ApiController.withIp(getApiIp(), getApiPort());
  }

  @override
  Future<Horaires> fetchHoraires(String username, String password, int gapsId,
      {bool decrypt = false}) async {
    try {
      final res = await dio.post<dynamic>('/horaires?decrypt=$decrypt',
          data: jsonEncode({
            'username': username,
            'password': password,
            'gapsId': gapsId,
          }));

      final Map<String, dynamic> json = res.data;
      final List<dynamic> horairesJson = json['VEVENT'];
      // final List<dynamic> calendarJson = json['VCALENDAR'];

      // final Map<String, dynamic> rrule0 =
      //    Map<String, dynamic>.from(calendarJson[0]);
      // final List<dynamic> rrule1 = rrule0['VTIMEZONE'];
      // final Map<String, dynamic> rrule2 = Map<String, dynamic>.from(rrule1[0]);
      // final List<dynamic> rrule3 = rrule2['STANDARD'];
      // final Map<String, dynamic> rrule4 = Map<String, dynamic>.from(rrule3[0]);
      // final String rrule = rrule4['RRULE'];

      final List<HeureDeCours> horaires = horairesJson
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
    try {
      final res = await dio.post<dynamic>('/notes?decrypt=$decrypt',
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
    try {
      final res = await dio.get<dynamic>('/menus');
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
    try {
      return (await dio.get<dynamic>('/public_key')).data['publicKey']
          as String;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Erreur lors de la récupération de la clé public');
    }
  }

  @override
  Future<User> fetchUser(String username, String password, int gapsId,
      {bool decrypt = false}) async {
    try {
      final response = await dio.post<dynamic>(
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
    try {
      return (await dio.post<dynamic>(
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
}
