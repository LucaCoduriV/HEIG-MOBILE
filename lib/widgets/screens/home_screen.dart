import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/api_controller.dart';
import 'package:heig_front/controllers/auth_controller.dart';
import 'package:heig_front/controllers/horaires_provider.dart';
import 'package:heig_front/controllers/navigator_controller.dart';
import 'package:heig_front/controllers/todos_provider.dart';
import 'package:heig_front/controllers/user_provider.dart';
import 'package:heig_front/models/heure_de_cours.dart';
import 'package:heig_front/models/todo.dart';
import 'package:heig_front/widgets/heure_de_cours_widget.dart';
import 'package:heig_front/widgets/tache_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<HeureDeCours> h =
        Provider.of<HorairesProvider>(context).getDailyClasses(DateTime.now());
    List<Todo> t =
        Provider.of<TodosProvider>(context).getTodos().values.toList();
    t.sort((a, b) => a.date.compareTo(b.date));
    t = t.where((todo) => !todo.completed).toList();

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
                  margin: EdgeInsets.only(left: 20),
                  child: CircleAvatar(
                    foregroundImage: NetworkImage(
                      Provider.of<UserProvider>(context).getAvatarUrl,
                    ),
                    radius: 50,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  height: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Salut ${Provider.of<UserProvider>(context).user.firstname}",
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
          SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 25),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: "Cours du jours",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: " (${h.length})",
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          child: Text("Tous"),
                          onTap: () {
                            NavigatorController.toHoraires(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: h.length != 0
                        ? ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 10);
                            },
                            itemCount: h.length,
                            itemBuilder: (context, index) {
                              return HeureDeCoursWidget(
                                  h[index].debut,
                                  h[index].fin,
                                  h[index].nom,
                                  h[index].prof,
                                  h[index].salle);
                            },
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [const Text("Pas de cours")],
                          ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: "Vos tâches",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: " (${t.length})",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          child: const Text("Tous"),
                          onTap: () {
                            NavigatorController.toTodos(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: t.length != 0
                        ? ListView.separated(
                            padding: EdgeInsets.symmetric(
                                vertical: 30, horizontal: 20),
                            itemCount: t.length,
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) {
                              return const SizedBox(width: 10);
                            },
                            itemBuilder: (context, index) {
                              return TacheWidget(
                                t[index].title,
                                t[index].date,
                                t[index].description,
                              );
                            },
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [const Text("Pas de tâche")],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
