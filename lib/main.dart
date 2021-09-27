import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/services/providers/settings_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:vrouter/vrouter.dart';

import 'models/branche.dart';
import 'models/bulletin.dart';
import 'models/heure_de_cours.dart';
import 'models/horaires.dart';
import 'models/notes.dart';
import 'models/todo.dart';
import 'models/user.dart';
import 'routes/main_router.dart';
import 'services/api_controller.dart';
import 'services/auth_controller.dart';
import 'services/navigator_controller.dart' as navigator_controller;
import 'services/notifications_manager.dart';
import 'services/providers/bulletin_provider.dart';
import 'services/providers/drawer_provider.dart';
import 'services/providers/horaires_provider.dart';
import 'services/providers/todos_provider.dart';
import 'services/providers/user_provider.dart';
import 'services/theme_data.dart' as theme;

/// Prparation de la base de données local et des singletons.
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
  await Hive.openBox('heig-settings');

  GetIt.I.registerSingleton<NotificationsManager>(NotificationsManager());
  GetIt.I.registerSingleton<BulletinProvider>(BulletinProvider());
  GetIt.I.registerSingleton<ApiController>(ApiController());
  GetIt.I.registerSingleton<AuthController>(AuthController());
  GetIt.I.registerSingleton<DrawerProvider>(DrawerProvider());
  GetIt.I.registerSingleton<TodosProvider>(TodosProvider());
  GetIt.I.registerSingleton<UserProvider>(UserProvider());
  GetIt.I.registerSingleton<HorairesProvider>(HorairesProvider());
  GetIt.I.registerSingleton<SettingsProvider>(SettingsProvider());
  GetIt.I.registerSingleton<theme.ThemeProvider>(theme.ThemeProvider());
  GetIt.I.registerSingleton<GlobalKey<RefreshIndicatorState>>(
      GlobalKey<RefreshIndicatorState>());

  final nM = GetIt.I.get<NotificationsManager>();
  await nM.initialize();
  nM.onNotification.asBroadcastStream().listen((event) {
    debugPrint(event.payload.toString());
    switch (event.payload?['page']) {
      case 'todo':
        debugPrint('TODO');
        if (event.buttonKeyInput == 'valider') {
          GetIt.I
              .get<TodosProvider>()
              .completeTodo(event.payload!['id']!, completed: true);
        }

        break;
      default:
        debugPrint('DEFAULT');
        break;
    }
  });
}

Future<void> main() async {
  try {
    await setup();

    runApp(const MyApp());
  } catch (e) {
    debugPrint(e.toString());
  }
}

/// Point d'entrée de l'application.
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode mode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: GetIt.I.get<theme.ThemeProvider>(),
      builder: (context, _) {
        return VRouter(
          theme: theme.themeLight,
          darkTheme: theme.themeDark,
          themeMode: Provider.of<theme.ThemeProvider>(context).mode,
          debugShowCheckedModeBanner: false,
          buildTransition: buildTransition,
          mode: VRouterMode.history, // Remove the '#' from the url
          logs: foundation.kReleaseMode
              ? VLogs.none
              : VLogs.info, // Defines which logs to show, info is the default
          initialUrl: '/${navigator_controller.home}',
          routes: MainRouter().buildRoutes(),
        );
      },
    );
  }
}

/// Transition entre les différentes routes.
Widget buildTransition(
    Animation<double> animation1, Animation<double> _, Widget child) {
  return SlideTransition(
    position: Tween(begin: const Offset(1, 0), end: const Offset(0, 0))
        .animate(animation1),
    child: child,
  );
}
