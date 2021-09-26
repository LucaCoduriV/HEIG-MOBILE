import 'package:get_it/get_it.dart';
import 'package:vrouter/vrouter.dart';

import '../services/navigator_controller.dart' as navigator_controller;
import '../services/providers/drawer_provider.dart';
import '../widgets/screens/settings_screen.dart';

class SettingsRoute extends VRouteElementBuilder {
  @override
  List<VRouteElement> buildRoutes() {
    return [
      VGuard(
        beforeEnter: (stackedRoutes) async {
          GetIt.I<DrawerProvider>().title = 'Options';
          GetIt.I<DrawerProvider>().action = ActionType.NONE;
        },
        stackedRoutes: [
          VWidget(
            path: '/${navigator_controller.settings}',
            widget: const SettingsScreen(),
          ),
        ],
      )
    ];
  }
}