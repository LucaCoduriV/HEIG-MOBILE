import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../controllers/bulletin_provider.dart';
import '../../controllers/horaires_provider.dart';
import '../../controllers/navigator_controller.dart';
import '../../controllers/todos_provider.dart';
import '../../controllers/user_provider.dart';
import '../../models/heure_de_cours.dart';
import '../../models/todo.dart';
import '../heure_de_cours_widget.dart';
import '../tache_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: GetIt.I<BulletinProvider>(),
        ),
        ChangeNotifierProvider.value(
          value: GetIt.I<UserProvider>(),
        ),
        ChangeNotifierProvider.value(
          value: GetIt.I<TodosProvider>(),
        ),
        ChangeNotifierProvider.value(
          value: GetIt.I<HorairesProvider>(),
        ),
      ],
      builder: (context, child) {
        final List<HeureDeCours> h = Provider.of<HorairesProvider>(context)
            .getDailyClasses(DateTime.now());
        List<Todo> t =
            Provider.of<TodosProvider>(context).getTodos().values.toList();
        t.sort((a, b) => a.date.compareTo(b.date));
        t = t.where((todo) => !todo.completed).toList();

        return Container(
          color: const Color(0xFFF9F9FB),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red.shade200,
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          foregroundImage:
                              Provider.of<UserProvider>(context).getAvatarUrl !=
                                      ''
                                  ? NetworkImage(
                                      Provider.of<UserProvider>(context)
                                          .getAvatarUrl,
                                    )
                                  : null,
                          radius: 50,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      margin: const EdgeInsets.only(left: 20),
                      height: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Salut ${Provider.of<UserProvider>(context).user.firstname}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Voici les nouveautés...',
                            style: TextStyle(fontWeight: FontWeight.w300),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 25),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: 'Cours du jours',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: ' (${h.length})',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                NavigatorController.toHoraires(context);
                              },
                              child: const Text('Tous'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: h.isNotEmpty
                            ? ListView.separated(
                                physics: const AlwaysScrollableScrollPhysics(
                                    parent: BouncingScrollPhysics()),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                separatorBuilder: (context, index) {
                                  return const SizedBox(height: 10);
                                },
                                itemCount: h.length,
                                itemBuilder: (context, index) {
                                  return HeureDeCoursWidget(
                                    h[index].debut,
                                    h[index].fin,
                                    h[index].nom,
                                    h[index].salle,
                                    h[index].prof,
                                  );
                                },
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [Text('Pas de cours')],
                              ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: 'Vos tâches',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: ' (${t.length})',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                NavigatorController.toTodos(context);
                              },
                              child: const Text('Tous'),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: t.isNotEmpty
                            ? ListView.separated(
                                physics: const AlwaysScrollableScrollPhysics(
                                    parent: BouncingScrollPhysics()),
                                padding: const EdgeInsets.symmetric(
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
                                children: const [Text('Pas de tâche')],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
