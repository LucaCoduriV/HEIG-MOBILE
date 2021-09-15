import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/drawer_provider.dart';
import 'package:heig_front/controllers/navigator_controller.dart';
import 'package:heig_front/widgets/screens/agenda_screen.dart';
import 'package:vrouter/vrouter.dart';

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
            path: '/${NavigatorController.todos}',
            widget: const AgendaScreen(), //TodosScreen(),
          )
        ],
      ),
    ];
  }
}
