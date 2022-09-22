import 'dart:io';

import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_dropdown_alert/dropdown_alert.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heig_front/services/api/iapi.dart';
import 'package:heig_front/services/providers/menus_provider.dart';
import 'package:heig_front/services/providers/settings_provider.dart';
import 'package:heig_front/utils/id_generator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:vrouter/vrouter.dart';
import 'package:workmanager/workmanager.dart';

import 'models/branche.dart';
import 'models/bulletin.dart';
import 'models/heure_de_cours.dart';
import 'models/horaires.dart';
import 'models/notes.dart';
import 'models/user.dart';
import 'routes/main_router.dart';
import 'services/api/api.dart';
import 'services/auth/auth.dart';
import 'services/auth/iauth.dart';
import 'services/background_tasks/check_new_grades.dart';
import 'services/providers/bulletin_provider.dart';
import 'services/providers/drawer_provider.dart';
import 'services/providers/horaires_provider.dart';
import 'services/providers/user_provider.dart';
import 'settings/theme.dart' as theme;
import 'utils/constants.dart';
import 'utils/navigation.dart' as navigation;
import 'utils/notification.dart';

/// Prparation de la base de données local et des singletons.
Future<void> setup() async {
  await initializeDateFormatting('fr_FR');
  tz.initializeTimeZones();
  await dotenv.load(mergeWith: Platform.environment);
  await Hive.initFlutter();
  await IdGenerator.initialize();
  Hive
    ..registerAdapter(BulletinAdapter())
    ..registerAdapter(BrancheAdapter())
    ..registerAdapter(HeureDeCoursAdapter())
    ..registerAdapter(HorairesAdapter())
    ..registerAdapter(NoteAdapter())
    ..registerAdapter(UserAdapter());

  await Hive.openBox<dynamic>(BOX_HEIG);
  await Hive.openBox<dynamic>('heig-settings');

  GetIt.I
    ..registerSingleton<IAPI>(ApiController())
    ..registerSingleton<IAuth>(Auth())
    ..registerSingleton<BulletinProvider>(BulletinProvider())
    ..registerSingleton<DrawerProvider>(DrawerProvider())
    ..registerSingleton<UserProvider>(UserProvider())
    ..registerSingleton<HorairesProvider>(HorairesProvider())
    ..registerSingleton<SettingsProvider>(SettingsProvider())
    ..registerSingleton<theme.ThemeProvider>(theme.ThemeProvider())
    ..registerSingleton<MenusProvider>(MenusProvider())
    ..registerSingleton<GlobalKey<RefreshIndicatorState>>(
        GlobalKey<RefreshIndicatorState>());
  GetIt.I.registerSingleton<NotificationController>(NotificationController());
  await GetIt.I.get<NotificationController>().initialize();

  final bool canNotify =
      await GetIt.I.get<NotificationController>().canNotifiy();

  if (!canNotify) {
    await GetIt.I
        .get<FlutterLocalNotificationsPlugin>()
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
  Workmanager().registerPeriodicTask(
    'newGradeChecker',
    'Check for new grades',
    frequency: const Duration(minutes: 15),
    constraints: Constraints(networkType: NetworkType.connected),
    existingWorkPolicy: ExistingWorkPolicy.replace,
    backoffPolicy: BackoffPolicy.linear,
    tag: 'authTask',
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
          theme: theme.themeLight.copyWith(
            textTheme: GoogleFonts.montserratTextTheme(
              theme.themeLight.textTheme,
            ),
          ),
          darkTheme: theme.themeDark.copyWith(
            textTheme: GoogleFonts.montserratTextTheme(
              theme.themeDark.textTheme,
            ),
          ),
          themeMode: Provider.of<theme.ThemeProvider>(context).mode,
          debugShowCheckedModeBanner: false,
          buildTransition: buildTransition,
          mode: VRouterMode.history, // Remove the '#' from the url
          // ignore: avoid_redundant_argument_values
          logs: foundation.kReleaseMode
              ? VLogs.none
              : VLogs.info, // Defines which logs to show, info is the default
          initialUrl: '/${navigation.RouteName.SETTINGS_ALERT}',
          routes: MainRouter().buildRoutes(),
          builder: (BuildContext context, Widget child) {
            return Stack(
              children: [
                child,
                const DropdownAlert(),
              ],
            );
          },
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
