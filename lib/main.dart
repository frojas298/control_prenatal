import 'package:flutter/material.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/registration': (context) => const RegistrationFormPage(),
        '/prenatal': (context) => const PrenatalCarePage(),
        '/hospitals': (context) => const HospitalsPage(),
      },
    );
  }
}
