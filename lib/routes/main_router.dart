import 'package:get_it/get_it.dart';
import 'package:heig_front/routes/settings_route.dart';
import 'package:vrouter/vrouter.dart';

import '../controllers/auth_controller.dart';
import '../controllers/navigator_controller.dart' as navigator_controller;
import '../widgets/my_drawer.dart';
import 'bulletin_route.dart';
import 'home_route.dart';
import 'horaires_route.dart';
import 'login_route.dart';
import 'todos_route.dart';

class MainRouter {
  List<VRouteElement> buildRoutes() {
    return [
      LoginRoute(),
      VGuard(
        beforeEnter: (vRedirector) async {
          if (!GetIt.I<AuthController>().isConnected) {
            vRedirector.to('/${navigator_controller.login}');
          }
        },
        stackedRoutes: [
          VNester(
            path: '/${navigator_controller.home}',
            widgetBuilder: (child) => MyDrawer(child: child),
            nestedRoutes: [
              HomeRoute(),
              BulletinRoute(),
              HorairesRoute(),
              TodosRoute(),
              SettingsRoute(),
            ],
          ),
        ],
      ),
      VRouteRedirector(
        redirectTo: '/${navigator_controller.home}',
        path: ':_(.*)', // .* is a regexp which matching every paths
      ),
    ];
  }
}
