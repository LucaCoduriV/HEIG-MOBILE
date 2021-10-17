import 'package:get_it/get_it.dart';
import 'package:vrouter/vrouter.dart';

import '../services/navigation.dart' as navigator_controller;
import '../services/providers/bulletin_provider.dart';
import '../services/providers/drawer_provider.dart';
import '../widgets/screens/bulletin_screen.dart';
import '../widgets/screens/notes_details.dart';

class BulletinRoute extends VRouteElementBuilder {
  @override
  List<VRouteElement> buildRoutes() {
    return [
      VGuard(
        beforeEnter: (stackedRoutes) async {
          GetIt.I<DrawerProvider>().title = 'Notes';
          GetIt.I<DrawerProvider>().action = ActionType.Notes;
          GetIt.I<BulletinProvider>().fetchBulletin();
        },
        stackedRoutes: [
          VWidget(
            path: '/${navigator_controller.NOTES}',
            widget: const BulletinScreen(),
            stackedRoutes: [
              VWidget(
                path: ':id',
                widget: const NotesDetails(),
              )
            ],
          )
        ],
      ),
    ];
  }
}
