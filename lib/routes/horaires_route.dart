import 'package:get_it/get_it.dart';
import 'package:vrouter/vrouter.dart';

import '../controllers/drawer_provider.dart';
import '../controllers/horaires_provider.dart';
import '../controllers/navigator_controller.dart';
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
            path: '/${NavigatorController.horaires}',
            widget: const HorairesScreen(),
          ),
        ],
      ),
    ];
  }
}
