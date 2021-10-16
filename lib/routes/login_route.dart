import 'package:vrouter/vrouter.dart';

import '../services/navigation.dart' as navigator_controller;
import '../widgets/screens/login_screen.dart';

class LoginRoute extends VRouteElementBuilder {
  @override
  List<VRouteElement> buildRoutes() {
    return [
      VWidget(
        path: '/${navigator_controller.login}',
        widget: const LoginScreen(),
      ),
    ];
  }
}
