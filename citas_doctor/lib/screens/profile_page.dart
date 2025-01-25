import "dart:convert";

import "package:citas_doctor/main.dart";
import "package:citas_doctor/utils/config.dart";
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../providers/dio_provider.dart";

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? token;
  Map<String, dynamic>? user; 
  bool isLoading = true; 

  Future<void> getUser() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('token') ?? '';

      if (token != null && token!.isNotEmpty) {
        final response = await DioProvider().getUser(token!);

        if (response != null && response is String) {
          final decodedResponse = jsonDecode(response) as Map<String, dynamic>;
          setState(() {
            user = decodedResponse;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            user = null;
          });
          print("Error: Respuesta inesperada de getUser -> $response");
        }
      } else {
        setState(() {
          isLoading = false;
          user = null;
        });
      }
    } catch (e) {
      print("Error en getUser: $e");
      setState(() {
        isLoading = false;
        user = null; 
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUser(); 
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (user == null) {
      return Center(child: Text("No se pudo cargar la información del usuario."));
    }

    return Column(
      children: [
        Expanded(
          flex: 4,
          child: Container(
            width: double.infinity,
            color: Config.primaryColor,
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 65,
                ),
                const CircleAvatar(
                  radius: 65.0,
                  backgroundImage: AssetImage('assets/lucin.png'),
                  backgroundColor: Colors.white,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  user!['name'] ?? 'Sin nombre',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Mostrar la bio_data del usuario.
                Text(
                  user!['bio_data'] ?? 'Sin información',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            color: Colors.grey[200],
            child: Center(
              child: Card(
                margin: const EdgeInsets.fromLTRB(0, 45, 0, 0),
                child: Container(
                  width: 300,
                  height: 250,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const Text(
                          'Opciones',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Divider(
                          color: Colors.grey[300],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.blueAccent[400],
                              size: 35,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Perfil",
                                style: TextStyle(
                                  color: Config.primaryColor,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Config.spaceSmall,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.history,
                              color: Colors.yellowAccent[400],
                              size: 35,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Historia",
                                style: TextStyle(
                                  color: Config.primaryColor,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Config.spaceSmall,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.logout_outlined,
                              color: Colors.lightGreen[400],
                              size: 35,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            TextButton(
                              onPressed: () async {
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                final token = prefs.getString('token') ?? '';

                                if (token.isNotEmpty && token != '') {
                                  
                                  final response =
                                      await DioProvider().logout(token);

                                  if (response == 200) {

                                    await prefs.remove('token');
                                    setState(() {
                                      
                                      MyApp.navigatorKey.currentState!
                                          .pushReplacementNamed('/');
                                    });
                                  }
                                }
                              },
                              child: const Text(
                                "Cerrar Sesión",
                                style: TextStyle(
                                  color: Config.primaryColor,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
