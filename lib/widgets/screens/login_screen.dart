import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/auth_controller.dart';
import 'package:heig_front/controllers/navigator_controller.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
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
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter your name',
                      ),
                      onChanged: (event) => log(event),
                      autocorrect: false,
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
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                      ),
                      obscureText: true,
                      controller: password,
                      autocorrect: false,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    GetIt.I<AuthController>().username = username.text;
                    GetIt.I<AuthController>().password = password.text;
                    if (await GetIt.I<AuthController>().login())
                      NavigatorController.toNotes(context);
                  }
                },
                child: Text("Login"),
              ),
            ],
          ),
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
