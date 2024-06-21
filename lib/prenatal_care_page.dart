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

class PrenatalCareDetailsPage extends StatefulWidget {
  final String weekRange;

  const PrenatalCareDetailsPage({required this.weekRange, super.key});

  @override
  _PrenatalCareDetailsPageState createState() => _PrenatalCareDetailsPageState();
}

class _PrenatalCareDetailsPageState extends State<PrenatalCareDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  String? _imc;
  String? _talla;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles Semana ${widget.weekRange}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.white, // Asegura el fondo blanco
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: ListView(
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
                  decoration: InputDecoration(
                    labelText: 'IMC',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un valor';
                    }
                    final n = num.tryParse(value);
                    if (n == null) {
                      return 'Por favor ingrese un valor numérico';
                    }
                    return null;
                  },
                  onSaved: (value) => _imc = value,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Talla',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un valor';
                    }
                    final n = num.tryParse(value);
                    if (n == null) {
                      return 'Por favor ingrese un valor numérico';
                    }
                    return null;
                  },
                  onSaved: (value) => _talla = value,
                ),
                const SizedBox(height: 16.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Éxito'),
                              content: const Text('Formulario enviado de manera exitosa'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Text('Enviar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
