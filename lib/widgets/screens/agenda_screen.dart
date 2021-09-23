import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/todo.dart';
import '../../services/providers/todos_provider.dart';
import '../todo_info.dart';

/// Page contenant la liste des tâches.
class AgendaScreen extends StatefulWidget {
  const AgendaScreen({Key? key}) : super(key: key);

  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: GetIt.I<TodosProvider>(),
      builder: (context, child) {
        final List<Todo> dailyTasks =
            Provider.of<TodosProvider>(context).getDailyTodos(_selectedDay);
        dailyTasks.sort((a, b) => a.date.compareTo(b.date));
        return Container(
          color: Theme.of(context).backgroundColor,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    TableCalendar<Todo>(
                      calendarBuilders: CalendarBuilders(
                        selectedBuilder: (context, date, events) => Container(
                            margin: const EdgeInsets.all(4),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius: BorderRadius.circular(50)),
                            child: Text(
                              date.day.toString(),
                              style: TextStyle(
                                  color: Theme.of(context).backgroundColor),
                            )),
                        todayBuilder: (context, date, events) => Container(
                            margin: const EdgeInsets.all(4),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.redAccent.shade100,
                                borderRadius: BorderRadius.circular(50)),
                            child: Text(
                              date.day.toString(),
                              style: const TextStyle(color: Colors.white),
                            )),
                      ),
                      locale: 'fr_FR',
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                      onFormatChanged: (format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      selectedDayPredicate: (day) {
                        return _selectedDay == day;
                      },
                      eventLoader: (DateTime day) {
                        return Provider.of<TodosProvider>(context)
                            .getDailyTodos(day)
                            .where((element) => !element.completed)
                            .toList();
                      },
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.55,
                        ),
                        Container(
                          height: 60,
                          width: 50,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedDay = DateTime.now();
                                _focusedDay = DateTime.now();
                              });
                            },
                            child: const Icon(Icons.today),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Text(
                              'Vos tâches',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: dailyTasks.isNotEmpty
                              ? ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 20),
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: dailyTasks.length,
                                  itemBuilder: (context, index) {
                                    return TodoInfo(todo: dailyTasks[index]);
                                  },
                                )
                              : const Text('Aucune tâche'),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
