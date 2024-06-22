import 'package:flutter/material.dart';

class HospitalsPage extends StatelessWidget {
  const HospitalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospitales'),
        // Eliminamos el leading para quitar la flecha de regreso
      ),
      body: Center(
        child: const Text('Información sobre hospitales'),
      ),
    );
  }
}
