import 'package:flutter/material.dart';
import 'package:heig_front/controllers/todos_provider.dart';
import 'package:heig_front/widgets/week_page.dart';
import 'package:provider/provider.dart';
import 'package:heig_front/utils/date.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({Key? key}) : super(key: key);

  @override
  _TodosScreenState createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  late PageController controller;
  final DateTime startYear = DateTime(2010).firstDayOfWeek();
  final DateTime endYear = DateTime(2030).firstDayOfWeek();
  @override
  void initState() {
    int page =
        DateTime.now().firstDayOfWeek().difference(startYear).inDays ~/ 7;
    super.initState();
    controller = PageController(initialPage: page);
  }

  @override
  Widget build(BuildContext context) {
    final int numberOfWeek = endYear.difference(startYear).inDays ~/ 7;

    return Container(
      color: Colors.white,
      child: PageView.builder(
        controller: controller,
        physics: const BouncingScrollPhysics(),
        itemCount: numberOfWeek,
        itemBuilder: (context, index) {
          final firstDayOfWeek = startYear.add(Duration(days: index * 7));
          return WeekPage(
            weekTasks: Provider.of<TodosProvider>(context)
                .getTodosByWeek(firstDayOfWeek),
            firstDayOfWeek: firstDayOfWeek,
          );
        },
      ),
    );
  }
}
