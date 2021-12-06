/// Ce fichier contient les fonctions qui permettent de gérer la navigation.

import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';

class RouteName {
  static const String LOGIN = 'login';
  static const String HORAIRES = 'horaires';
  static const String HOME = 'home';
  static const String NOTES = 'notes';
  static const String TODOS = 'todos';
  static const String SETTINGS = 'settings';
  static const String MENU = 'menu';
}

void toLogin(BuildContext context) {
  VRouter.of(context).to('/${RouteName.LOGIN}');
}

void toHome(BuildContext context) {
  VRouter.of(context).to('/${RouteName.HOME}');
}

void toNotes(BuildContext context) {
  VRouter.of(context).to('/${RouteName.NOTES}');
}

void toHoraires(BuildContext context) {
  VRouter.of(context).to('/${RouteName.HORAIRES}');
}

void toTodos(BuildContext context) {
  VRouter.of(context).to('/${RouteName.TODOS}');
}

void toNoteDetails(BuildContext context, int noteId) {
  VRouter.of(context).to('/${RouteName.NOTES}/$noteId');
}

void toSettings(BuildContext context) {
  VRouter.of(context).to('/${RouteName.SETTINGS}');
}

void toMenu(BuildContext context) {
  VRouter.of(context).to('/${RouteName.MENU}');
}
