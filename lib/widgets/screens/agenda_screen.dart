import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/todos_provider.dart';
import 'package:heig_front/models/todo.dart';
import 'package:heig_front/widgets/task_info.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

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
    List<Todo> dailyTasks =
        Provider.of<TodosProvider>(context).getDailyTodos(_selectedDay);

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          TableCalendar<Todo>(
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
          Expanded(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: dailyTasks.length != 0
                  ? ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: dailyTasks.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            TaskInfo(todo: dailyTasks[index]),
                            dailyTasks.length != index + 1
                                ? Container(
                                    margin: EdgeInsets.symmetric(vertical: 3),
                                    height: 1,
                                    color: Colors.grey,
                                  )
                                : SizedBox()
                          ],
                        );
                      },
                    )
                  : Text("Aucune tâche"),
            ),
          )
        ],
      ),
    );
  }
}
