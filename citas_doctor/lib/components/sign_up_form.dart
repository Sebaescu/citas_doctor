import 'package:citas_doctor/components/button.dart';
import 'package:citas_doctor/main.dart';
import 'package:citas_doctor/models/auth_model.dart';
import 'package:citas_doctor/providers/dio_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/config.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool obsecurePass = true;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            keyboardType: TextInputType.text,
            cursorColor: Config.primaryColor,
            decoration: const InputDecoration(
              hintText: 'Nombre de Usuario',
              labelText: 'Nombre de Usuario',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.person_outlined),
              prefixIconColor: Config.primaryColor,
            ),
          ),
          Config.spaceSmall,
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Config.primaryColor,
            decoration: const InputDecoration(
              hintText: 'Correo Electrónico',
              labelText: 'Correo',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.email_outlined),
              prefixIconColor: Config.primaryColor,
            ),
          ),
          Config.spaceSmall,
          TextFormField(
            controller: _passController,
            keyboardType: TextInputType.visiblePassword,
            cursorColor: Config.primaryColor,
            obscureText: obsecurePass,
            decoration: InputDecoration(
                hintText: 'Contraseña',
                labelText: 'Contraseña',
                alignLabelWithHint: true,
                prefixIcon: const Icon(Icons.lock_outline),
                prefixIconColor: Config.primaryColor,
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obsecurePass = !obsecurePass;
                      });
                    },
                    icon: obsecurePass
                        ? const Icon(
                            Icons.visibility_off_outlined,
                            color: Colors.black38,
                          )
                        : const Icon(
                            Icons.visibility_outlined,
                            color: Config.primaryColor,
                          ))),
          ),
          Config.spaceSmall,
          Consumer<AuthModel>(
            builder:(context,auth,child){
              return Button(
                width: double.infinity,
                title: 'Registro',
                onPressed: () async {
                  final userRegistration = await DioProvider().registerUser(
                      _nameController.text,
                      _emailController.text,
                      _passController.text);

                  if (userRegistration) {
                    final token = await DioProvider()
                        .getToken(_emailController.text, _passController.text);

                    if (token) {
                      auth.loginSuccess({}, {});
                      
                      MyApp.navigatorKey.currentState!.pushNamed('main');
                    }
                  } else {
                    print('Registro fallido');
                  }
                },
                disable: false,
              );
            },
          )
        ],
      ),
    );
  }
}