import 'package:get_it/get_it.dart';
import 'package:heig_front/widgets/screens/settings_alert_screen.dart';
import 'package:vrouter/vrouter.dart';

import '../services/providers/settings_provider.dart';
import '../utils/navigation.dart';

class SettingsAlertRoute extends VRouteElementBuilder {
  @override
  List<VRouteElement> buildRoutes() {
    return [
      VGuard(
        beforeEnter: (vRedirector) async {
          if (!GetIt.I<SettingsProvider>().showBatteryOptimizationAlert) {
            vRedirector.to('/${RouteName.HOME}');
          }
        },
        stackedRoutes: [
          VWidget(
            path: '/${RouteName.SETTINGS_ALERT}',
            widget: const SettingsAlertScreen(),
          ),
        ],
      )
    ];
  }
}
