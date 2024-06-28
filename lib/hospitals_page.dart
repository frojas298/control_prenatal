import 'package:flutter/material.dart';

class HospitalsPage extends StatelessWidget {
  const HospitalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> hospitals = [
      {
        'name': 'Hospital Angeles',
        'address': 'Av. Universidad 250, Copilco, 04360 Ciudad de México, CDMX',
        'phone': '55 5668 0798',
      },
      {
        'name': 'Hospital San José',
        'address': 'Calle 10 No. 278, Col. San José Insurgentes, Del. Benito Juárez, 03900 Ciudad de México, CDMX',
        'phone': '55 5550 9100',
      },
      {
        'name': 'IMSS',
        'address': 'Av. Paseo de la Reforma 476, Juárez, 06600 Ciudad de México, CDMX',
        'phone': '800 623 2323',
      },
      {
        'name': 'ISSSTE',
        'address': 'Av. de la República 154, Tabacalera, 06030 Ciudad de México, CDMX',
        'phone': '55 4000 1000',
      },
      {
        'name': 'Star Medica',
        'address': 'Av. Ejército Nacional Mexicano 613, Granada, 11520 Ciudad de México, CDMX',
        'phone': '55 5272 1111',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospitales'),
      ),
      body: ListView.builder(
        itemCount: hospitals.length,
        itemBuilder: (context, index) {
          final hospital = hospitals[index];
          return Card(
            child: ListTile(
              title: Text(hospital['name']!),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dirección: ${hospital['address']}'),
                  Text('Teléfono: ${hospital['phone']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
