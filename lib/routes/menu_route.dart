import 'package:get_it/get_it.dart';
import 'package:heig_front/widgets/screens/menu_screen.dart';
import 'package:vrouter/vrouter.dart';

import '../services/navigator_controller.dart' as navigator_controller;
import '../services/providers/drawer_provider.dart';

class MenuRoute extends VRouteElementBuilder {
  @override
  List<VRouteElement> buildRoutes() {
    return [
      VGuard(
        beforeEnter: (stackedRoutes) async {
          GetIt.I<DrawerProvider>().title = 'Menu de la semaine';
          GetIt.I<DrawerProvider>().action = ActionType.NONE;
        },
        stackedRoutes: [
          VWidget(
            path: '/${navigator_controller.menu}',
            widget: const MenuScreen(),
          ),
        ],
      )
    ];
  }
}