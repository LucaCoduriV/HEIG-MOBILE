import 'package:vrouter/vrouter.dart';

class NavigatorController {
  static String login = "login";
  static String notes = "notes";
  static String horaires = "horaires";
  static String home = "home";

  static void toLogin(context) {
    VRouter.of(context).to("/$home/$login");
  }

  static void toNotes(context) {
    VRouter.of(context).to("/$home/$notes");
  }

  static void toHoraires(context) {
    VRouter.of(context).to("/$home/$horaires");
  }

  static void toNoteDetails(context, int noteId) {
    VRouter.of(context).to("/$home/$notes/$noteId");
  }
}
