import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:vrouter/vrouter.dart';

import 'controllers/api_controller.dart';
import 'controllers/auth_controller.dart';
import 'controllers/bulletin_provider.dart';
import 'controllers/drawer_provider.dart';
import 'controllers/horaires_provider.dart';
import 'controllers/navigator_controller.dart';
import 'controllers/notifications_manager.dart';
import 'controllers/todos_provider.dart';
import 'controllers/user_provider.dart';
import 'models/branche.dart';
import 'models/bulletin.dart';
import 'models/heure_de_cours.dart';
import 'models/horaires.dart';
import 'models/notes.dart';
import 'models/todo.dart';
import 'models/user.dart';
import 'routes/main_router.dart';

Future<void> setup() async {
  await initializeDateFormatting('fr_FR');
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

  await GetIt.I.get<NotificationsManager>().initialize();
}

Future<void> main() async {
  try {
    await setup();

    runApp(const MyApp());
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
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: Colors.grey),
        primaryColor: Colors.white, //Color(0xffda291c),
        accentColor: const Color(0xffdf4d52),
        inputDecorationTheme: const InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xffda291c)),
        )),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xffda291c),
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      debugShowCheckedModeBanner: false, // VRouter acts as a MaterialApp
      buildTransition: (animation1, _, child) => SlideTransition(
        position: Tween(begin: const Offset(1, 0), end: const Offset(0, 0))
            .animate(animation1),
        child: child,
      ),
      mode: VRouterMode.history, // Remove the '#' from the url
      logs: foundation.kReleaseMode
          ? VLogs.none
          : VLogs.info, // Defines which logs to show, info is the default
      initialUrl: '/${NavigatorController.home}',
      routes: MainRouter().buildRoutes(),
    );
  }
}
