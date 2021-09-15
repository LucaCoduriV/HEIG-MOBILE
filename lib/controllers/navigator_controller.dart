import 'package:vrouter/vrouter.dart';

class NavigatorController {
  static String login = "login";
  static String notes = "notes";
  static String horaires = "horaires";
  static String home = "home";
  static String todos = "todos";

  static void toLogin(context) {
    VRouter.of(context).to("/$login");
  }

  static void toHome(context) {
    VRouter.of(context).to("/$home");
  }

  static void toNotes(context) {
    VRouter.of(context).to("/$notes");
  }

  static void toHoraires(context) {
    VRouter.of(context).to("/$horaires");
  }

  static void toTodos(context) {
    VRouter.of(context).to("/$todos");
  }

  static void toNoteDetails(context, int noteId) {
    VRouter.of(context).to("/$notes/$noteId");
  }
}
