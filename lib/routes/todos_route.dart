import 'package:get_it/get_it.dart';
import 'package:vrouter/vrouter.dart';

import '../controllers/drawer_provider.dart';
import '../controllers/navigator_controller.dart' as navigator_controller;
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
            path: '/${navigator_controller.todos}',
            widget: const AgendaScreen(), //TodosScreen(),
          )
        ],
      ),
    ];
  }
}
