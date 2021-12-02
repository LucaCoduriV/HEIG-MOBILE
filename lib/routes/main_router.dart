import 'package:get_it/get_it.dart';
import 'package:heig_front/routes/settings_route.dart';
import 'package:heig_front/services/auth/iauth.dart';
import 'package:heig_front/services/background_tasks/check_new_grades.dart';
import 'package:vrouter/vrouter.dart';

import '../services/navigation.dart' as navigator_controller;
import '../widgets/my_drawer.dart';
import 'bulletin_route.dart';
import 'home_route.dart';
import 'horaires_route.dart';
import 'login_route.dart';
import 'menu_route.dart';
import 'todos_route.dart';

class MainRouter {
  List<VRouteElement> buildRoutes() {
    return [
      LoginRoute(),
      VGuard(
        beforeEnter: (vRedirector) async {
          if (!GetIt.I<IAuth>().isConnected) {
            vRedirector.to('/${navigator_controller.LOGIN}');
          } else {
            startBackgroundTask();
          }
        },
        stackedRoutes: [
          VNester(
            path: '/${navigator_controller.HOME}',
            widgetBuilder: (child) => MyDrawer(child: child),
            nestedRoutes: [
              HomeRoute(),
              BulletinRoute(),
              HorairesRoute(),
              MenuRoute(),
              TodosRoute(),
              SettingsRoute(),
            ],
          ),
        ],
      ),
      VRouteRedirector(
        redirectTo: '/${navigator_controller.HOME}',
        path: ':_(.*)', // .* is a regexp which matching every paths
      ),
    ];
  }
}
