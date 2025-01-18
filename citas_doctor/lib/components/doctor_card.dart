
import 'package:citas_doctor/utils/config.dart';
import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    Key? key, required this.route, required this.doctor
  }) : super(key: key);

  final String route;
  final Map<String,dynamic> doctor;
  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 150,
      child: GestureDetector(
        child: Card(
          elevation: 5,
          color: Colors.white,
          child: Row(
            children: [
              SizedBox(
                width: Config.widthSize * 0.33,
                child: Image.network(
                  'http://127.0.0.1:8000${doctor['doctor_profile']}',
                  fit: BoxFit.fill,
                ),
              ),
              Flexible(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Dr ${doctor['doctor_name']}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        '${doctor['category']}',,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Icon(
                            Icons.star_border,
                            color: Colors.yellow,
                            size: 16,
                          ),
                          const Spacer(
                            flex: 1,
                          ),
                          const Text('4.5'),
                          const Spacer(
                            flex: 1,
                          ),
                          const Text('Reseñas'),
                          const Spacer(
                            flex: 1,
                          ),
                          const Text('(20)'),
                          const Spacer(
                            flex: 7,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.of(context).pushNamed(route,arguments:doctor);
        },
      ),
    );
  }
}
