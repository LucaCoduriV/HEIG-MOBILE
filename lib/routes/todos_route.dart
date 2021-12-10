import 'package:get_it/get_it.dart';
import 'package:vrouter/vrouter.dart';

import '../services/providers/drawer_provider.dart';
import '../utils/navigation.dart';
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
            path: '/${RouteName.TODOS}',
            widget: const AgendaScreen(), //TodosScreen(),
          )
        ],
      ),
    ];
  }
}
