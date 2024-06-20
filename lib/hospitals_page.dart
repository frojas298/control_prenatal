import 'package:flutter/material.dart';

class HospitalsPage extends StatelessWidget {
  const HospitalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospitales'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: const Text('Información sobre hospitales'),
      ),
    );
  }
}
