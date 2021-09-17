import 'package:heig_front/widgets/screens/settings_screen.dart';
import 'package:vrouter/vrouter.dart';

import '../controllers/navigator_controller.dart' as navigator_controller;

class SettingsRoute extends VRouteElementBuilder {
  @override
  List<VRouteElement> buildRoutes() {
    return [
      VWidget(
        path: '/${navigator_controller.settings}',
        widget: const SettingsScreen(),
      ),
    ];
  }
}
