import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';

class NavigatorController {
  static String login = 'login';
  static String notes = 'notes';
  static String horaires = 'horaires';
  static String home = 'home';
  static String todos = 'todos';

  static void toLogin(BuildContext context) {
    VRouter.of(context).to('/$login');
  }

  static void toHome(BuildContext context) {
    VRouter.of(context).to('/$home');
  }

  static void toNotes(BuildContext context) {
    VRouter.of(context).to('/$notes');
  }

  static void toHoraires(BuildContext context) {
    VRouter.of(context).to('/$horaires');
  }

  static void toTodos(BuildContext context) {
    VRouter.of(context).to('/$todos');
  }

  static void toNoteDetails(BuildContext context, int noteId) {
    VRouter.of(context).to('/$notes/$noteId');
  }
}
