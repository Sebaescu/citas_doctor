import 'package:citas_doctor/screens/booking_page.dart';
import 'package:citas_doctor/screens/cancel_booked.dart';
import 'package:citas_doctor/screens/success_booked.dart';
import 'package:flutter/material.dart';
import 'package:citas_doctor/utils/config.dart';
import 'package:citas_doctor/screens/auth_page.dart';
import 'package:citas_doctor/main_layout.dart';
import 'package:provider/provider.dart';
import 'package:citas_doctor/models/auth_model.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthModel>(
      create:(context)=>AuthModel(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Flutter Doctor App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          inputDecorationTheme: const InputDecorationTheme(
            focusColor: Config.primaryColor,
            border: Config.outlinedBorder,
            focusedBorder: Config.focusBorder,
            errorBorder: Config.errorBorder,
            enabledBorder: Config.outlinedBorder,
            floatingLabelStyle: TextStyle(color: Config.primaryColor),
            prefixIconColor: Colors.black38,
          ),
          scaffoldBackgroundColor: Colors.white,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Config.primaryColor,
            selectedItemColor: Colors.white,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            unselectedItemColor: Colors.grey.shade700,
            elevation: 10,
            type: BottomNavigationBarType.fixed,
          ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthPage(),
        'main': (context) => const MainLayout(),
        'booking_page': (context) => BookingPage(),
        'success_booked': (context) => const AppointmentBooked(),
        'cancel_booked': (context) => const AppointmentCancel(),
      },
    ));
  }
}

