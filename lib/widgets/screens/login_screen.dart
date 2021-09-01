import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/auth_controller.dart';
import 'package:heig_front/controllers/bulletin_provider.dart';
import 'package:heig_front/controllers/horaires_provider.dart';
import 'package:heig_front/controllers/navigator_controller.dart';
import 'package:heig_front/controllers/user_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController username =
      new TextEditingController(text: GetIt.I<AuthController>().username);
  TextEditingController password = new TextEditingController();
  var _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final Widget svg = SvgPicture.asset(
      'assets/images/logo.svg',
      semanticsLabel: 'HEIG Logo',
      width: 100,
      color: Color(0xffda291c), //Theme.of(context).primaryColor,
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            svg,
            SizedBox(height: 50),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 200,
                        child: TextFormField(
                          validator: validator,
                          decoration: InputDecoration(
                            hintText: 'Enter your name',
                          ),
                          controller: username,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 200,
                        child: TextFormField(
                          validator: validator,
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                          ),
                          obscureText: true,
                          controller: password,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(100, 40),
                      primary: Colors.teal,
                      side: BorderSide(
                        color: Color(0xffda291c),
                        width: 1,
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Dialog(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              child: new Center(
                                child: new CircularProgressIndicator(
                                  color: Color(0xffda291c),
                                ), //Theme.of(context).primaryColor),
                              ),
                            );
                          },
                        );
                        GetIt.I<AuthController>().username = username.text;
                        GetIt.I<AuthController>().password = password.text;

                        if (await GetIt.I<AuthController>().login()) {
                          NavigatorController.toQuickInfos(context);
                          GetIt.I.get<UserProvider>().fetchUser();
                          GetIt.I.get<HorairesProvider>().fetchHoraires();
                          GetIt.I.get<BulletinProvider>().fetchBulletin(
                              year: GetIt.I<BulletinProvider>().year);
                        }

                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      "Login",
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
