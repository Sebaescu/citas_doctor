
import 'package:citas_doctor/components/button.dart';
import 'package:flutter/material.dart';

import '../utils/config.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
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
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Config.primaryColor,
            decoration: const InputDecoration(
              hintText: 'Correo Electrónico',
              labelText: 'Correo Electrónico',
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
            builder: (context,auth,child){
              return Button(
                width: double.infinity, 
                title: 'Iniciar Sesión', 
                onPressed: ()async {
                  final token=await DioProvider().getToken(_emailController.text,_passController.text);
                  if(token){
                    auth.loginSuccess();
                    MyApp.navigatorKey.currentState!.pushNamed('main');
                  }
                  final user=await DioProvider().getUser();
                  //print(token);
                  Navigator.of(context).pushNamed('main');
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
