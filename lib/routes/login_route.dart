import 'package:vrouter/vrouter.dart';

import '../services/navigation.dart';
import '../widgets/screens/login_screen.dart';

class LoginRoute extends VRouteElementBuilder {
  @override
  List<VRouteElement> buildRoutes() {
    return [
      VWidget(
        path: '/${RouteName.LOGIN}',
        widget: const LoginScreen(),
      ),
    ];
  }
}
