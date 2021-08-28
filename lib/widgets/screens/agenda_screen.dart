import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:heig_front/controllers/todos_provider.dart';
import 'package:heig_front/models/todo.dart';
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
            focusedDay: DateTime.now(),
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onDaySelected: (day, day2) {
              setState(() {
                _selectedDay = day;
              });
            },
            selectedDayPredicate: (day) {
              return _selectedDay == day;
            },
            eventLoader: (DateTime day) {
              return Provider.of<TodosProvider>(context).getDailyTodos(day);
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dailyTasks.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    onTap: () => print('${dailyTasks[index].title}'),
                    title: Text('${dailyTasks[index].title}'),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
