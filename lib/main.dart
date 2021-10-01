import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/services/providers/settings_provider.dart';
import 'package:heig_front/utils/id_generator.dart';
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
  await IdGenerator.initialize();
  await Hive.openBox<dynamic>('heig');
  await Hive.openBox<dynamic>('heig-settings');

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

  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'todos_channel',
        channelName: 'Todo',
        channelDescription: 'Notification channel for todos',
        defaultColor: Colors.red,
        ledColor: Colors.white,
      ),
      NotificationChannel(
        channelKey: 'horaires_channel',
        channelName: 'Horaire',
        channelDescription: 'Notification channel for schedules',
        defaultColor: Colors.red,
        ledColor: Colors.white,
      ),
    ],
  );
  await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // Insert here your friendly dialog box before call the request method
      // This is very important to not harm the user experience
      AwesomeNotifications().requestPermissionToSendNotifications();
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
