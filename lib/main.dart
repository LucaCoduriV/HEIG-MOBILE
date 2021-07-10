import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/api_controller.dart';
import 'package:heig_front/controllers/branche_provider.dart';
import 'package:heig_front/controllers/navigator_controller.dart';
import 'package:heig_front/widgets/my_drawer.dart';
import 'package:heig_front/widgets/screens/horaires_screen.dart';
import 'package:heig_front/widgets/screens/login_screen.dart';
import 'package:heig_front/widgets/screens/notes_details.dart';
import 'package:heig_front/widgets/screens/notes_screen.dart';
import 'package:vrouter/vrouter.dart';
import 'package:flutter/material.dart';

Future<void> setup() async {
  await dotenv.load();
  GetIt.I.registerSingleton<BulletinProvider>(BulletinProvider());
  GetIt.I.registerSingleton<ApiController>(ApiController());
}

void main() async {
  await setup();
  runApp(
    VRouter(
      debugShowCheckedModeBanner: false, // VRouter acts as a MaterialApp
      buildTransition: (animation1, _, child) => SlideTransition(
        position: Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
            .animate(animation1),
        child: child,
      ),
      mode: VRouterMode.history, // Remove the '#' from the url
      logs: VLogs.info, // Defines which logs to show, info is the default
      routes: [
        VWidget(
          path: "/${NavigatorController.login}",
          widget: LoginScreen(),
        ),
        VNester(
          path: "/${NavigatorController.home}",
          widgetBuilder: (child) => MyDrawer(child: child),
          nestedRoutes: [
            VNester(
              path: NavigatorController.notes,
              widgetBuilder: (child) => child,
              nestedRoutes: [
                VWidget(
                  path: null,
                  widget: NotesScreen(),
                ),
                VWidget(
                  path: ":id",
                  widget: NotesDetails(),
                )
              ],
            ),
            VWidget(
              path: NavigatorController.horaires,
              widget: HorairesScreen(),
            ),
          ],
        ),
        VRouteRedirector(
          redirectTo: "/${NavigatorController.login}",
          path: r':_(.*)', // .* is a regexp which matching every paths
        ),
      ],
    ),
  );
}
