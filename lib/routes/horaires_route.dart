import 'package:get_it/get_it.dart';
import 'package:vrouter/vrouter.dart';

import '../services/providers/drawer_provider.dart';
import '../services/providers/horaires_provider.dart';
import '../services/navigator_controller.dart' as navigator_controller;
import '../widgets/screens/horaires_screen.dart';

class HorairesRoute extends VRouteElementBuilder {
  @override
  List<VRouteElement> buildRoutes() {
    return [
      VGuard(
        beforeEnter: (stackedRoutes) async {
          GetIt.I.get<HorairesProvider>().fetchHoraires();
          GetIt.I<DrawerProvider>().title = 'Horaires';
          GetIt.I<DrawerProvider>().action = ActionType.NONE;
        },
        stackedRoutes: [
          VWidget(
            path: '/${navigator_controller.horaires}',
            widget: const HorairesScreen(),
          ),
        ],
      ),
    ];
  }
}
