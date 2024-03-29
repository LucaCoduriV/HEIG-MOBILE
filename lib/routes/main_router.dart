import 'package:get_it/get_it.dart';
import 'package:heig_front/routes/settings_alert_route.dart';
import 'package:heig_front/routes/settings_route.dart';
import 'package:heig_front/services/auth/iauth.dart';
import 'package:heig_front/services/background_tasks/check_new_grades.dart';
import 'package:heig_front/settings/env_settings.dart';
import 'package:vrouter/vrouter.dart';

import '../utils/navigation.dart';
import '../widgets/my_drawer.dart';
import 'bulletin_route.dart';
import 'home_route.dart';
import 'horaires_route.dart';
import 'login_route.dart';
import 'menu_route.dart';

class MainRouter {
  List<VRouteElement> buildRoutes() {
    return [
      LoginRoute(),
      SettingsAlertRoute(),
      VGuard(
        beforeEnter: (vRedirector) async {
          if (!GetIt.I<IAuth>().isConnected) {
            stopBackgroundTask();
            vRedirector.to('/${RouteName.LOGIN}');
          } else {
            startBackgroundTask(backgroundTaskDuration());
          }
        },
        stackedRoutes: [
          VNester(
            path: '/${RouteName.HOME}',
            widgetBuilder: (child) => MyDrawer(child: child),
            nestedRoutes: [
              HomeRoute(),
              BulletinRoute(),
              HorairesRoute(),
              MenuRoute(),
              SettingsRoute(),
            ],
          ),
        ],
      ),
      VRouteRedirector(
        redirectTo: '/${RouteName.HOME}',
        path: ':_(.*)', // .* is a regexp which matching every paths
      ),
    ];
  }
}
