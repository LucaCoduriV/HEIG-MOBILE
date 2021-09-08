import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/api_controller.dart';
import 'package:heig_front/controllers/auth_controller.dart';
import 'package:heig_front/controllers/bulletin_provider.dart';
import 'package:heig_front/controllers/drawer_provider.dart';
import 'package:heig_front/controllers/horaires_provider.dart';
import 'package:heig_front/controllers/navigator_controller.dart';
import 'package:heig_front/controllers/notifications_manager.dart';
import 'package:heig_front/controllers/todos_provider.dart';
import 'package:heig_front/controllers/user_provider.dart';
import 'package:heig_front/models/branche.dart';
import 'package:heig_front/models/bulletin.dart';
import 'package:heig_front/models/heure_de_cours.dart';
import 'package:heig_front/models/horaires.dart';
import 'package:heig_front/models/notes.dart';
import 'package:heig_front/models/todo.dart';
import 'package:heig_front/models/user.dart';
import 'package:heig_front/widgets/my_drawer.dart';
import 'package:heig_front/widgets/screens/agenda_screen.dart';
import 'package:heig_front/widgets/screens/home_screen.dart';
import 'package:heig_front/widgets/screens/horaires_screen.dart';
import 'package:heig_front/widgets/screens/login_screen.dart';
import 'package:heig_front/widgets/screens/notes_details.dart';
import 'package:heig_front/widgets/screens/bulletin_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vrouter/vrouter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> setup() async {
  await initializeDateFormatting("fr_FR");
  await dotenv.load();
  await Hive.initFlutter();
  Hive.registerAdapter(BulletinAdapter());
  Hive.registerAdapter(BrancheAdapter());
  Hive.registerAdapter(HeureDeCoursAdapter());
  Hive.registerAdapter(HorairesAdapter());
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(TodoAdapter());
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox('heig');

  GetIt.I.registerSingleton<BulletinProvider>(BulletinProvider());
  GetIt.I.registerSingleton<ApiController>(ApiController());
  GetIt.I.registerSingleton<AuthController>(AuthController());
  GetIt.I.registerSingleton<DrawerProvider>(DrawerProvider());
  GetIt.I.registerSingleton<TodosProvider>(TodosProvider());
  GetIt.I.registerSingleton<UserProvider>(UserProvider());
  GetIt.I.registerSingleton<HorairesProvider>(HorairesProvider());
  GetIt.I.registerSingleton<NotificationsManager>(NotificationsManager());
  GetIt.I.registerSingleton<GlobalKey<RefreshIndicatorState>>(
      GlobalKey<RefreshIndicatorState>());

  GetIt.I.get<NotificationsManager>().initialize();
}

void main() async {
  try {
    await setup();

    runApp(MyApp());
  } catch (e) {
    debugPrint(e.toString());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VRouter(
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.grey),
        primaryColor: Colors.white, //Color(0xffda291c),
        accentColor: Color(0xffdf4d52),
        inputDecorationTheme: InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xffda291c)),
        )),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xffda291c),
          textTheme: ButtonTextTheme.primary,
        ),
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
            if (GetIt.I<AuthController>().isConnected) {
              vRedirector.to(
                  ("/${NavigatorController.home}/${NavigatorController.quickInfos}"));
            }
          },
          stackedRoutes: [
            VWidget(
              path: "/${NavigatorController.login}",
              widget: const LoginScreen(),
            ),
          ],
        ),
        VGuard(
          beforeEnter: (vRedirector) async {
            if (!GetIt.I<AuthController>().isConnected) {
              vRedirector.to(("/${NavigatorController.login}"));
            }
          },
          stackedRoutes: [
            VNester(
              path: "/${NavigatorController.home}",
              widgetBuilder: (child) => ChangeNotifierProvider.value(
                value: GetIt.I<DrawerProvider>(),
                child: MyDrawer(child: child),
              ),
              nestedRoutes: [
                //quickInfos
                VNester(
                  path: NavigatorController.quickInfos,
                  widgetBuilder: (child) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider.value(
                        value: GetIt.I<BulletinProvider>(),
                      ),
                      ChangeNotifierProvider.value(
                        value: GetIt.I<UserProvider>(),
                      ),
                      ChangeNotifierProvider.value(
                        value: GetIt.I<TodosProvider>(),
                      ),
                      ChangeNotifierProvider.value(
                        value: GetIt.I<HorairesProvider>(),
                      ),
                    ],
                    child: child,
                  ),
                  nestedRoutes: [
                    VGuard(
                      beforeEnter: (stackedRoutes) async {
                        GetIt.I<DrawerProvider>().title = '';
                        GetIt.I<DrawerProvider>().action =
                            ActionType.QUICKINFOS;
                      },
                      stackedRoutes: [
                        VWidget(
                          path: null,
                          widget: const HomeScreen(),
                        )
                      ],
                    ),
                  ],
                ),
                // /notes
                VNester(
                  path: NavigatorController.notes,
                  widgetBuilder: (child) => ChangeNotifierProvider.value(
                    value: GetIt.I<BulletinProvider>(),
                    child: child,
                  ),
                  nestedRoutes: [
                    VGuard(
                      beforeEnter: (stackedRoutes) async {
                        GetIt.I<DrawerProvider>().title = 'Notes';
                        GetIt.I<DrawerProvider>().action = ActionType.Notes;
                        GetIt.I<BulletinProvider>().fetchBulletin();
                      },
                      stackedRoutes: [
                        VWidget(
                          path: null,
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
                  ],
                ),
                // /horaires
                VGuard(
                  beforeEnter: (stackedRoutes) async {
                    GetIt.I.get<HorairesProvider>().fetchHoraires();
                    GetIt.I<DrawerProvider>().title = 'Horaires';
                    GetIt.I<DrawerProvider>().action = ActionType.NONE;
                  },
                  stackedRoutes: [
                    VNester(
                        path: NavigatorController.horaires,
                        widgetBuilder: (child) => ChangeNotifierProvider.value(
                              value: GetIt.I<HorairesProvider>(),
                              child: child,
                            ),
                        nestedRoutes: [
                          VWidget(
                            path: null,
                            widget: const HorairesScreen(),
                          )
                        ])
                  ],
                ),
                // /todos
                VNester(
                  path: NavigatorController.todos,
                  widgetBuilder: (child) => ChangeNotifierProvider.value(
                    value: GetIt.I<TodosProvider>(),
                    child: child,
                  ),
                  nestedRoutes: [
                    VGuard(
                      beforeEnter: (stackedRoutes) async {
                        GetIt.I<DrawerProvider>().title = 'Agenda';
                        GetIt.I<DrawerProvider>().action = ActionType.TODOS;
                      },
                      stackedRoutes: [
                        VWidget(
                          path: null,
                          widget: const AgendaScreen(), //TodosScreen(),
                        )
                      ],
                    ),
                  ],
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
