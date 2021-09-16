import 'package:vrouter/vrouter.dart';

import '../controllers/navigator_controller.dart';
import '../widgets/screens/login_screen.dart';

class LoginRoute extends VRouteElementBuilder {
  @override
  List<VRouteElement> buildRoutes() {
    return [
      VWidget(
        path: '/${NavigatorController.login}',
        widget: const LoginScreen(),
      ),
    ];
  }
}
