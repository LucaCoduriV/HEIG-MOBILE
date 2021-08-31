import 'package:flutter/material.dart';
import 'package:heig_front/controllers/horaires_provider.dart';
import 'package:heig_front/models/heure_de_cours.dart';
import 'package:heig_front/widgets/heure_de_cours_widget.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class HorairesScreen extends StatefulWidget {
  const HorairesScreen({Key? key}) : super(key: key);

  @override
  _HorairesScreenState createState() => _HorairesScreenState();
}

class _HorairesScreenState extends State<HorairesScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    HorairesProvider h = Provider.of<HorairesProvider>(context);
    List<HeureDeCours> coursJour = h.getDailyClasses(_selectedDay);

    return Container(
      color: Color(0xFFF9F9FB),
      child: Container(
        padding: EdgeInsets.only(top: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            TableCalendar<HeureDeCours>(
              headerVisible: false,
              calendarBuilders: CalendarBuilders(
                selectedBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    )),
                todayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.red.shade200,
                        borderRadius: BorderRadius.circular(50.0)),
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
                return Provider.of<HorairesProvider>(context)
                    .getDailyClasses(day);
              },
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
                          "Vos Cours",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: coursJour.length != 0
                          ? ListView.separated(
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 20),
                              physics: AlwaysScrollableScrollPhysics(
                                  parent: BouncingScrollPhysics()),
                              itemCount: coursJour.length,
                              itemBuilder: (context, index) {
                                return HeureDeCoursWidget(
                                  coursJour[index].debut,
                                  coursJour[index].fin,
                                  coursJour[index].nom,
                                  coursJour[index].salle,
                                  coursJour[index].prof,
                                );
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
