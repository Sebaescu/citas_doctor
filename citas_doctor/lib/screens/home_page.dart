import 'package:citas_doctor/components/appointment_card.dart';
import 'package:citas_doctor/components/doctor_card.dart';
import 'package:citas_doctor/models/auth_model.dart';
import 'package:citas_doctor/screens/doctorListScreen';
import 'package:citas_doctor/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  Map<String, dynamic> user = {};
  Map<String, dynamic> doctor = {};
  List<dynamic> favList = [];
  List<Map<String, dynamic>> medCat = [
    {
      "icon": FontAwesomeIcons.userDoctor,
      "category": "General",
    },
    {
      "icon": FontAwesomeIcons.heartPulse,
      "category": "Cardiología",
    },
    {
      "icon": FontAwesomeIcons.lungs,
      "category": "Respiración",
    },
    {
      "icon": FontAwesomeIcons.hand,
      "category": "Dermatología",
    },
    {
      "icon": FontAwesomeIcons.personPregnant,
      "category": "Ginecología",
    },
    {
      "icon": FontAwesomeIcons.teeth,
      "category": "Odontología",
    },
  ];

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    user = Provider.of<AuthModel>(context, listen: false).getUser;
    doctor = Provider.of<AuthModel>(context, listen: false).getAppointment;
    favList = Provider.of<AuthModel>(context, listen: false).getFavDoc;
    return Scaffold(
      body: user.isEmpty?
      const Center(child: CircularProgressIndicator(),)
      : Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      user['name'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/lucin.png'),
                      ),
                    )
                  ],
                ),
                Config.spaceMedium,
                const Text(
                  'Categorías',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Config.spaceSmall,
                  SizedBox(
                        height: Config.heightSize * 0.07,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children:
                              List<Widget>.generate(medCat.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DoctorListScreen(
                                        category: medCat[index]['category']),
                                  ),
                                );
                              },
                              child: Card(
                                margin: const EdgeInsets.only(right: 25),
                                color: Config.primaryColor,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      FaIcon(
                                        medCat[index]['icon'],
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 25),
                                      Text(
                                        medCat[index]['category'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),

                Config.spaceSmall,
                const Text(
                  'Próxima Cita',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Config.spaceSmall,
                doctor.isNotEmpty
                  ? AppointmentCard(
                      doctor: doctor,
                      color: Config.primaryColor,
                    )
                  : Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'No tiene Citas',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                Config.spaceSmall,
                const Text(
                  'Mejores Doctores',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Config.spaceSmall,
                Column(
                  children: List.generate(user['doctor'].length, (index) {
                    return DoctorCard(
                      doctor: user['doctor'][index],
                      isFav: favList
                            .contains(user['doctor'][index]['doc_id'])
                        ? true
                        : false,
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
