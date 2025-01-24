import 'package:citas_doctor/components/button.dart';
import 'package:citas_doctor/components/custom_appbar.dart';
import 'package:citas_doctor/main.dart';
import 'package:citas_doctor/providers/dio_provider.dart';
import 'package:citas_doctor/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/booking_datetime_converted.dart';



class BookingPage extends StatefulWidget {
  BookingPage({Key? key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {

  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  bool _isWeekend = false;
  bool _dateSelected = false;
  bool _timeSelected = false;
  String? token;

  Future<void> getToken()async{
    final SharedPreferences prefs=await SharedPreferences.getInstance();
    token=prefs.getString('token')??'';
  }

  @override
  void initState(){
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    final doctor=ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: CustomAppBar(
        appTitle: 'Calendario',
        icon: const FaIcon(Icons.arrow_back_ios),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                _tableCalendar(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                  child: Center(
                    child: Text(
                      'Seleciona tiempo de consulta',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          _isWeekend
              ? SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 30),
                    alignment: Alignment.center,
                    child: const Text(
                      'Fin de semana no disponible, intente otro día',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
              : SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            _currentIndex = index;
                            _timeSelected = true;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _currentIndex == index
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            color: _currentIndex == index
                                ? Config.primaryColor
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${index + 7}:00 ${index + 7 >= 12 ? (index + 7 == 12 ? "PM" : "PM") : "AM"}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  _currentIndex == index ? Colors.white : null,
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: 12,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, childAspectRatio: 1.5),
                ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 80),
              child: Button(
                width: double.infinity,
                title: 'Agendar Cita',
                onPressed: () async{
                  final getDate=DateConverted.getDate(_currentDay);
                  final getDay=DateConverted.getDay(_currentDay.weekday);
                  final getTime=DateConverted.getTime(_currentIndex!);

                  final booking = await DioProvider().bookAppoinment(
                      getDate, getDay, getTime, doctor['doctor_id'], token!);


                  if (booking == 200) {
                    MyApp.navigatorKey.currentState!
                        .pushNamed('success_booked');
                  }

                },
                disable: _timeSelected && _dateSelected ? false : true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableCalendar() {
    return TableCalendar(
      locale: 'es_ES',
      focusedDay: _focusDay,
      firstDay: DateTime.now(),
      lastDay: DateTime(2025, 12, 31),
      calendarFormat: _format,
      currentDay: _currentDay,
      rowHeight: 60,
      calendarStyle: const CalendarStyle(
        todayDecoration:
            BoxDecoration(color: Config.primaryColor, shape: BoxShape.circle),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        weekendStyle:
            TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
        dowTextFormatter: (date, locale) =>
            DateFormat.E(locale).format(date).substring(0, 3).toUpperCase(),
      ),
      availableCalendarFormats: const {
        CalendarFormat.month: 'Mes',
      },
      onFormatChanged: (format) {
        setState(() {
          _format = format;
        });
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _currentDay = selectedDay;
          _focusDay = focusedDay;
          _dateSelected = true;

          if (selectedDay.weekday == 6 || selectedDay.weekday == 7) {
            _isWeekend = true;
            _timeSelected = false;
            _currentIndex = null;
          } else {
            _isWeekend = false;
          }
        });
      },
    );
  }

}
