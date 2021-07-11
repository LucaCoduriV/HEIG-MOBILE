import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/api_controller.dart';
import 'package:heig_front/controllers/auth_controller.dart';
import 'package:heig_front/controllers/bulletin_provider.dart';
import 'package:heig_front/controllers/navigator_controller.dart';
import 'package:heig_front/models/branche.dart';
import 'package:heig_front/models/bulletin.dart';
import 'package:heig_front/models/heure_de_cours.dart';
import 'package:heig_front/models/horaires.dart';
import 'package:heig_front/models/notes.dart';
import 'package:heig_front/widgets/my_drawer.dart';
import 'package:heig_front/widgets/screens/horaires_screen.dart';
import 'package:heig_front/widgets/screens/login_screen.dart';
import 'package:heig_front/widgets/screens/notes_details.dart';
import 'package:heig_front/widgets/screens/bulletin_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vrouter/vrouter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> setup() async {
  await dotenv.load();
  await Hive.initFlutter();
  Hive.registerAdapter(BulletinAdapter());
  Hive.registerAdapter(BrancheAdapter());
  Hive.registerAdapter(HeureDeCoursAdapter());
  Hive.registerAdapter(HorairesAdapter());
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox('heig');

  GetIt.I.registerSingleton<BulletinProvider>(BulletinProvider());
  GetIt.I.registerSingleton<ApiController>(ApiController());
  GetIt.I.registerSingleton<AuthController>(AuthController());
}

void main() async {
  await setup();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VRouter(
      theme: ThemeData(
        primaryColor: Color(0xffda291c),
        accentColor: Color(0xffdf4d52),
      ),
      debugShowCheckedModeBanner: false, // VRouter acts as a MaterialApp
      buildTransition: (animation1, _, child) => SlideTransition(
        position: Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
            .animate(animation1),
        child: child,
      ),
      mode: VRouterMode.history, // Remove the '#' from the url
      logs: VLogs.info, // Defines which logs to show, info is the default
      routes: [
        VGuard(
          beforeEnter: (vRedirector) async {
            debugPrint(GetIt.I<AuthController>().isConnected.toString());
            if (GetIt.I<AuthController>().isConnected) {
              vRedirector.to(
                  ("/${NavigatorController.home}/${NavigatorController.notes}"));
            }
          },
          stackedRoutes: [
            VWidget(
              path: "/${NavigatorController.login}",
              widget: LoginScreen(),
            ),
          ],
        ),
        VGuard(
          beforeEnter: (vRedirector) async {
            debugPrint(GetIt.I<AuthController>().isConnected.toString());
            if (!GetIt.I<AuthController>().isConnected) {
              vRedirector.to(("/${NavigatorController.login}"));
            }
          },
          stackedRoutes: [
            VNester(
              path: "/${NavigatorController.home}",
              widgetBuilder: (child) => MyDrawer(child: child),
              nestedRoutes: [
                VNester(
                  path: NavigatorController.notes,
                  widgetBuilder: (child) => ChangeNotifierProvider.value(
                    value: GetIt.I<BulletinProvider>(),
                    child: child,
                  ),
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
          ],
        ),
        VRouteRedirector(
          redirectTo: "/${NavigatorController.login}",
          path: r':_(.*)', // .* is a regexp which matching every paths
        ),
      ],
    );
  }
}
