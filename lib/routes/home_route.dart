import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/drawer_provider.dart';
import 'package:heig_front/widgets/screens/home_screen.dart';
import 'package:vrouter/vrouter.dart';

class HomeRoute extends VRouteElementBuilder {
  final stackedRoutes;

  HomeRoute({this.stackedRoutes});

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
