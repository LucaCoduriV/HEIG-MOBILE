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
      color: Color(0xFFF9F9FB),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                TableCalendar<Todo>(
                  calendarBuilders: CalendarBuilders(
                    selectedBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(color: Colors.white),
                        )),
                    todayBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.redAccent.shade100,
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(color: Colors.white),
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
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: InkWell(
                        child: Container(
                          child: Icon(Icons.today),
                        ),
                        onTap: () {
                          setState(() {
                            _selectedDay = DateTime.now();
                            _focusedDay = DateTime.now();
                          });
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Vos tâches",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: dailyTasks.length != 0
                          ? ListView.separated(
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 20),
                              physics: BouncingScrollPhysics(),
                              itemCount: dailyTasks.length,
                              itemBuilder: (context, index) {
                                return TaskInfo(todo: dailyTasks[index]);
                              },
                            )
                          : Text("Aucune tâche"),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
