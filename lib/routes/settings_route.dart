import 'package:get_it/get_it.dart';
import 'package:vrouter/vrouter.dart';

import '../services/providers/drawer_provider.dart';
import '../utils/navigation.dart';
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
            path: '/${RouteName.SETTINGS}',
            widget: const SettingsScreen(),
          ),
        ],
      )
    ];
  }
}
