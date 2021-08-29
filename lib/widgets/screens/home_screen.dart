import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/auth_controller.dart';
import 'package:heig_front/controllers/user_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF9F9FB),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: 60,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        Provider.of<UserProvider>(context).user.avatarUrl),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  height: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Salut Luca",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Voici les nouveautés...",
                        style: TextStyle(fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: ElevatedButton(
                child: Text("test"),
                onPressed: () {
                  GetIt.I.get<UserProvider>().fetchUser(
                      GetIt.I.get<AuthController>().username,
                      GetIt.I.get<AuthController>().password,
                      GetIt.I.get<AuthController>().gapsId);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
