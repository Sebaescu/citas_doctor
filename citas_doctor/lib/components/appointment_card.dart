
import 'package:citas_doctor/main.dart';
import 'package:citas_doctor/providers/dio_provider.dart';
import 'package:citas_doctor/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentCard extends StatefulWidget {
  AppointmentCard({Key? key, required this.doctor, required this.color}): super(key: key);

  final Map<String, dynamic> doctor;
  final Color color;

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}


class _AppointmentCardState extends State<AppointmentCard> {
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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        "http://127.0.0.1:8000${widget.doctor['doctor_profile']}"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Dr ${widget.doctor['doctor_name']}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        widget.doctor['category'],
                        style: const TextStyle(color: Colors.black),
                      )
                    ],
                  ),
                ],
              ),
              Config.spaceSmall,
              ScheduleCard(
                appointment: widget.doctor['appointments'],
              ),
              Config.spaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: const FlutterLogo(
                                size: 100,
                              ),
                              title: const Text(
                                'Seguro que quieres cancelar la cita?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              actions: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .center, 
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              10), 
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); 
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors
                                          .red, 
                                        ),
                                        child: const Text(
                                          'No',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              10), 
                                      child: TextButton(
                                        onPressed: () async {

                                          final cancel = await DioProvider()
                                              .cancelAppointment(
                                                  widget.doctor['appointments']
                                                      ['id'],
                                                  token!);

                                          if (cancel == 200) {
                                            MyApp.navigatorKey.currentState!
                                                .pushNamed('cancel_booked');
                                          }

                                          Navigator.of(context)
                                              .pop();
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors
                                              .green, 
                                        ),
                                        child: const Text(
                                          'Sí',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      },

                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return RatingDialog(
                              initialRating: 1.0,
                              title: const Text(
                                'Puntua a nuestro Doctor',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              message: const Text(
                                '¿Cómo calificarías la atención de nuestro doctor?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              image: const FlutterLogo(
                                size: 100,
                              ),
                              submitButtonText: 'Enviar',
                              commentHint: 'Tu comentario aquí...',
                              onSubmitted: (response) async {
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                final token =
                                    prefs.getString('token') ?? '';

                                final rating = await DioProvider()
                                    .storeReviews(
                                        response.comment,
                                        response.rating,
                                        widget.doctor['appointments']
                                            ['id'], 
                                        widget.doctor[
                                            'doc_id'], 
                                        token);

                                if (rating == 200 && rating != '') {
                                  MyApp.navigatorKey.currentState!
                                      .pushNamed('main');
                                }
                              });
                        });
                      },
                      child: const Text(
                        'Completar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({Key? key, required this.appointment}) : super(key: key);
  final Map<String, dynamic> appointment;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.calendar_today,
            color: Colors.white,
            size: 15,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            '${appointment['day']}, ${appointment['date']}',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(
            width: 20,
          ),
          const Icon(
            Icons.access_alarm,
            color: Colors.white,
            size: 17,
          ),
          const SizedBox(
            width: 5,
          ),
          Flexible(
              child: Text(
            appointment['time'],
            style: TextStyle(color: Colors.white),
          ))
        ],
      ),
    );
  }
}
