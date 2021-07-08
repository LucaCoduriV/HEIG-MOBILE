import 'package:heig_front/widgets/my_drawer.dart';
import 'package:heig_front/widgets/screens/horaires_screen.dart';
import 'package:heig_front/widgets/screens/login_screen.dart';
import 'package:heig_front/widgets/screens/notes_screen.dart';
import 'package:vrouter/vrouter.dart';
import 'package:flutter/material.dart';

void main() {
  final String notes = 'notes';
  final String horaire = 'horaires';
  final String login = '/login';

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
          path: login,
          widget: LoginScreen(),
        ),
        VNester(
          path: '/home',
          widgetBuilder: (child) => MyDrawer(child: child),
          nestedRoutes: [
            VWidget(
              path: notes,
              widget: NotesScreen(),
            ), // path '/home/profile'
            VWidget(
              path: horaire,
              widget: HorairesScreen(),
            ), // path '/home/settings'
          ],
        ),
        // This redirect every unknown routes to /login
        VRouteRedirector(
          redirectTo: login,
          path: r':_(.*)', // .* is a regexp which matching every paths
        ),
      ],
    ),
  );
}
