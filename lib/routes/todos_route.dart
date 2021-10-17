import 'package:get_it/get_it.dart';
import 'package:vrouter/vrouter.dart';

import '../services/navigation.dart' as navigator_controller;
import '../services/providers/drawer_provider.dart';
import '../widgets/screens/agenda_screen.dart';

class TodosRoute extends VRouteElementBuilder {
  @override
  List<VRouteElement> buildRoutes() {
    return [
      VGuard(
        beforeEnter: (stackedRoutes) async {
          GetIt.I<DrawerProvider>().title = 'Agenda';
          GetIt.I<DrawerProvider>().action = ActionType.TODOS;
        },
        stackedRoutes: [
          VWidget(
            path: '/${navigator_controller.TODOS}',
            widget: const AgendaScreen(), //TodosScreen(),
          )
        ],
      ),
    ];
  }
}
