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
import 'package:heig_front/routes/main_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vrouter/vrouter.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/foundation.dart' as Foundation;

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
      logs: Foundation.kReleaseMode
          ? VLogs.none
          : VLogs.info, // Defines which logs to show, info is the default
      initialUrl: '/${NavigatorController.home}',
      routes: MainRouter().buildRoutes(),
    );
  }
}
