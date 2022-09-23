import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vrouter/vrouter.dart';

import '../../services/providers/settings_provider.dart';
import '../../utils/navigation.dart';

class SettingsAlertScreen extends StatelessWidget {
  const SettingsAlertScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final btnStyle = OutlinedButton.styleFrom(
      minimumSize: const Size(100, 40),
      foregroundColor: Colors.teal,
      side: const BorderSide(
        color: Color(0xffda291c),
      ),
    );
    return Material(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Pour que l'application fonctionne correctement, merci de désactiver l'optimisation de la batterie",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color(0xffda291c), fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            style: btnStyle,
            onPressed: () {
              GetIt.I<SettingsProvider>().showBatteryOptimizationAlert = false;
              context.vRouter.to('/${RouteName.HOME}');
              AppSettings.openBatteryOptimizationSettings();
            },
            child: const Text(
              'Changer les paramètres',
              style: TextStyle(color: Color(0xffda291c)),
            ),
          ),
          OutlinedButton(
            style: btnStyle,
            onPressed: () {
              GetIt.I<SettingsProvider>().showBatteryOptimizationAlert = false;
              context.vRouter.to('/${RouteName.HOME}');
            },
            child: const Text(
              'Continuer sans changer',
              style: TextStyle(color: Color(0xffda291c)),
            ),
          ),
        ],
      ),
    );
  }
}
