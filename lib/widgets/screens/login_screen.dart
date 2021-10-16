import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';

import '../../services/auth.dart';
import '../../services/navigation.dart' as navigator_controller;
import '../../services/providers/bulletin_provider.dart';
import '../../services/providers/horaires_provider.dart';
import '../../services/providers/user_provider.dart';

/// Page contenant le formulaire de connexion
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController username =
      TextEditingController(text: GetIt.I<AuthController>().username);
  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final Widget svg = SvgPicture.asset(
      'assets/images/logo.svg',
      semanticsLabel: 'HEIG Logo',
      width: 100,
      color: const Color(0xffda291c), //Theme.of(context).primaryColor,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            svg,
            const SizedBox(height: 50),
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 200,
                        child: TextFormField(
                          validator: validator,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Enter your name',
                          ),
                          controller: username,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 200,
                        child: TextFormField(
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                          validator: validator,
                          decoration: const InputDecoration(
                            hintText: 'Enter your password',
                          ),
                          obscureText: true,
                          controller: password,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(100, 40),
                      primary: Colors.teal,
                      side: const BorderSide(
                        color: Color(0xffda291c),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        showDialog<dynamic>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return const Dialog(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xffda291c),
                                ), //Theme.of(context).primaryColor),
                              ),
                            );
                          },
                        );
                        GetIt.I<AuthController>().username = username.text;
                        GetIt.I<AuthController>().password = password.text;

                        if (await GetIt.I<AuthController>().login()) {
                          navigator_controller.toHome(context);
                          GetIt.I.get<UserProvider>().fetchUser();
                          GetIt.I.get<HorairesProvider>()
                            ..fetchHoraires()
                            ..registerNotifications();
                          GetIt.I.get<BulletinProvider>().fetchBulletin();
                        } else {
                          AlertController.show(
                            'Error',
                            'Wrong username or password.',
                            TypeAlert.error,
                          );
                        }

                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Color(0xffda291c)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? validator(String? text) {
    if (text == null || text.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }
}
