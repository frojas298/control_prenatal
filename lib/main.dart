import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'registration_form_page.dart';
import 'prenatal_care_page.dart';
import 'hospitals_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control Prenatal App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => HomePage(nombre: ''), // This line is needed for route definition
        '/registration': (context) => const RegistrationFormPage(),
        '/prenatal': (context) => const PrenatalCarePage(),
        '/hospitals': (context) => const HospitalsPage(),
        '/login': (context) => const LoginPage(), // Ruta para cerrar sesión
      },
    );
  }
}
