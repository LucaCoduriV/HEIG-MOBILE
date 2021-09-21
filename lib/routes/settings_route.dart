import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/drawer_provider.dart';
import 'package:heig_front/widgets/screens/settings_screen.dart';
import 'package:vrouter/vrouter.dart';

import '../controllers/navigator_controller.dart' as navigator_controller;

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
