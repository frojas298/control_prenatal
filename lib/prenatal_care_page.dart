import 'package:flutter/material.dart';

class PrenatalCarePage extends StatelessWidget {
  const PrenatalCarePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Control Prenatal'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          PrenatalCareCard(weekRange: '4-8', description: 'Primer control'),
          PrenatalCareCard(weekRange: '11-14', description: 'Semana 11-14'),
          PrenatalCareCard(weekRange: '20-24', description: 'Semana 20-24'),
          PrenatalCareCard(weekRange: '26-28', description: 'Semana 26-28'),
          PrenatalCareCard(weekRange: '32-38', description: 'Semana 32-38'),
        ],
      ),
    );
  }
}

class PrenatalCareCard extends StatelessWidget {
  final String weekRange;
  final String description;

  const PrenatalCareCard({required this.weekRange, required this.description, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Semana $weekRange'),
        subtitle: Text(description),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PrenatalCareDetailsPage(weekRange: weekRange),
            ),
          );
        },
      ),
    );
  }
}

class PrenatalCareDetailsPage extends StatelessWidget {
  final String weekRange;

  const PrenatalCareDetailsPage({required this.weekRange, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles Semana $weekRange'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.white, // Asegura el fondo blanco
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[
            const Text(
              'Exámenes clínicos o laboratorios',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            DataTable(columns: const [
              DataColumn(label: Text('Tipo')),
              DataColumn(label: Text('Fecha')),
              DataColumn(label: Text('Resultado')),
            ], rows: const [
              DataRow(cells: [
                DataCell(Text('Examen de sangre')),
                DataCell(Text('15/06/2023')),
                DataCell(Text('Normal')),
              ]),
            ]),
            const SizedBox(height: 16.0),
            const Text(
              'Visitas ginecológicas',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            // Añadir más detalles de visitas ginecológicas
            const SizedBox(height: 16.0),
            const Text(
              'Exámenes Físicos',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'IMC'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Talla'),
            ),
          ],
        ),
      ),
    );
  }
}
