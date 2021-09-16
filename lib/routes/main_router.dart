import 'package:get_it/get_it.dart';
import 'package:vrouter/vrouter.dart';

import '../controllers/auth_controller.dart';
import '../controllers/navigator_controller.dart';
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
            vRedirector.to('/${NavigatorController.login}');
          }
        },
        stackedRoutes: [
          VNester(
            path: '/${NavigatorController.home}',
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
        redirectTo: '/${NavigatorController.home}',
        path: ':_(.*)', // .* is a regexp which matching every paths
      ),
    ];
  }
}
