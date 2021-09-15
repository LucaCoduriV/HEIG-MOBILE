import 'package:heig_front/controllers/navigator_controller.dart';
import 'package:heig_front/widgets/screens/login_screen.dart';
import 'package:vrouter/vrouter.dart';

class LoginRoute extends VRouteElementBuilder {
  @override
  List<VRouteElement> buildRoutes() {
    return [
      VWidget(
        path: "/${NavigatorController.login}",
        widget: const LoginScreen(),
      ),
    ];
  }
}
