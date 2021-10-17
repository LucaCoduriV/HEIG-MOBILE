/// Ce fichier contient les fonctions qui permettent de gérer la navigation.

import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';

const String LOGIN = 'login';
const String NOTES = 'notes';
const String HORAIRES = 'horaires';
const String HOME = 'home';
const String TODOS = 'todos';
const String SETTINGS = 'settings';
const String MENU = 'menu';

void toLogin(BuildContext context) {
  VRouter.of(context).to('/$LOGIN');
}

void toHome(BuildContext context) {
  VRouter.of(context).to('/$HOME');
}

void toNotes(BuildContext context) {
  VRouter.of(context).to('/$NOTES');
}

void toHoraires(BuildContext context) {
  VRouter.of(context).to('/$HORAIRES');
}

void toTodos(BuildContext context) {
  VRouter.of(context).to('/$TODOS');
}

void toNoteDetails(BuildContext context, int noteId) {
  VRouter.of(context).to('/$NOTES/$noteId');
}

void toSettings(BuildContext context) {
  VRouter.of(context).to('/$SETTINGS');
}

void toMenu(BuildContext context) {
  VRouter.of(context).to('/$MENU');
}
