/// Ce fichier contient les fonctions qui permettent de gérer la navigation.

import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';

const String login = 'login';
const String notes = 'notes';
const String horaires = 'horaires';
const String home = 'home';
const String todos = 'todos';
const String settings = 'settings';

void toLogin(BuildContext context) {
  VRouter.of(context).to('/$login');
}

void toHome(BuildContext context) {
  VRouter.of(context).to('/$home');
}

void toNotes(BuildContext context) {
  VRouter.of(context).to('/$notes');
}

void toHoraires(BuildContext context) {
  VRouter.of(context).to('/$horaires');
}

void toTodos(BuildContext context) {
  VRouter.of(context).to('/$todos');
}

void toNoteDetails(BuildContext context, int noteId) {
  VRouter.of(context).to('/$notes/$noteId');
}

void toSettings(BuildContext context) {
  VRouter.of(context).to('/$settings');
}
