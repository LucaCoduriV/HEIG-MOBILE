import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/auth_controller.dart';
import 'package:heig_front/controllers/navigator_controller.dart';
import 'package:heig_front/routes/todos_route.dart';
import 'package:heig_front/widgets/my_drawer.dart';
import 'package:vrouter/vrouter.dart';

import 'bulletin_route.dart';
import 'home_route.dart';
import 'horaires_route.dart';
import 'login_route.dart';

class MainRouter {
  List<VRouteElement> buildRoutes() {
    return [
      LoginRoute(),
      VGuard(
        beforeEnter: (vRedirector) async {
          if (!GetIt.I<AuthController>().isConnected) {
            vRedirector.to(("/${NavigatorController.login}"));
          }
        },
        stackedRoutes: [
          VNester(
            path: "/${NavigatorController.home}",
            widgetBuilder: (child) => MyDrawer(child: child),
            nestedRoutes: [
              HomeRoute(
                stackedRoutes: [
                  BulletinRoute(),
                  HorairesRoute(),
                  TodosRoute(),
                ],
              )
            ],
          ),
        ],
      ),
      VRouteRedirector(
        redirectTo: "/${NavigatorController.home}",
        path: r':_(.*)', // .* is a regexp which matching every paths
      ),
    ];
  }
}
