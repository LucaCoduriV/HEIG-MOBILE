import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/drawer_provider.dart';
import 'package:heig_front/controllers/horaires_provider.dart';
import 'package:heig_front/controllers/navigator_controller.dart';
import 'package:heig_front/widgets/screens/horaires_screen.dart';
import 'package:vrouter/vrouter.dart';

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
