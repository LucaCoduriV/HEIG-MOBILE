import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../models/todo.dart';
import '../../services/api/response_types/heure_de_cours.dart';
import '../../services/navigation.dart' as navigator_controller;
import '../../services/providers/bulletin_provider.dart';
import '../../services/providers/horaires_provider.dart';
import '../../services/providers/todos_provider.dart';
import '../../services/providers/user_provider.dart';
import '../heure_de_cours_widget.dart';
import '../todo_quick_info.dart';

/// Page contenant des informations rapides.
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
            Provider.of<TodosProvider>(context).todos.values.toList();
        t.sort((a, b) => a.date.compareTo(b.date));
        t = t.where((todo) => !todo.completed).toList();

        return Container(
          color: Theme.of(context).primaryColor,
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
                          color: Theme.of(context).colorScheme.secondary,
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
                    color: Theme.of(context).backgroundColor,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
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
                                navigator_controller.toHoraires(context);
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
                                navigator_controller.toTodos(context);
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
                                  return TodoQuickInfo(
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
