import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/bulletin_provider.dart';
import 'package:heig_front/controllers/drawer_provider.dart';
import 'package:heig_front/controllers/navigator_controller.dart';
import 'package:heig_front/widgets/screens/bulletin_screen.dart';
import 'package:heig_front/widgets/screens/notes_details.dart';
import 'package:vrouter/vrouter.dart';

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
            path: '/${NavigatorController.notes}',
            widget: BulletinScreen(),
            stackedRoutes: [
              VWidget(
                path: ":id",
                widget: const NotesDetails(),
              )
            ],
          )
        ],
      ),
    ];
  }
}
