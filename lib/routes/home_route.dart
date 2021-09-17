import 'package:get_it/get_it.dart';
import 'package:vrouter/vrouter.dart';

import '../controllers/drawer_provider.dart';
import '../widgets/screens/home_screen.dart';

class HomeRoute extends VRouteElementBuilder {
  final List<VRouteElement> stackedRoutes;

  HomeRoute({this.stackedRoutes = const []});

  @override
  List<VRouteElement> buildRoutes() {
    return [
      VGuard(
        beforeEnter: (stackedRoutes) async {
          GetIt.I<DrawerProvider>().title = '';
          GetIt.I<DrawerProvider>().action = ActionType.QUICKINFOS;
        },
        stackedRoutes: [
          VWidget(
            path: null,
            widget: const HomeScreen(),
            stackedRoutes: stackedRoutes,
          ),
        ],
      )
    ];
  }
}
