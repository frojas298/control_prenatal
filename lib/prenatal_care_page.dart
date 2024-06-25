import 'package:flutter/material.dart';
import 'database_helper.dart';

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
  final dbHelper = DatabaseHelper();
  String? _examenesClinicos;
  String? _visitasGinecologicas;
  double? _imc;
  double? _talla;
  List<Map<String, dynamic>> _controlPrenatalData = [];

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
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      const Text(
                        'Exámenes clínicos o laboratorios',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Exámenes Clínicos',
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
                        onSaved: (value) => _examenesClinicos = value,
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Visitas ginecológicas',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Visitas Ginecológicas',
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
                        onSaved: (value) => _visitasGinecologicas = value,
                      ),
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
                        onSaved: (value) => _imc = double.tryParse(value!),
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
                        onSaved: (value) => _talla = double.tryParse(value!),
                      ),
                      const SizedBox(height: 16.0),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              dbHelper.insertControlPrenatal({
                                'ID_Usuario': 1, // ID de ejemplo, debes obtener el ID real del usuario
                                'Semana': int.parse(widget.weekRange.split('-')[0]),
                                'Examenes_Clinicos': _examenesClinicos,
                                'Visitas_Ginecologicas': _visitasGinecologicas,
                                'IMC': _imc,
                                'Talla': _talla
                              });
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
                      const SizedBox(height: 16.0),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            _queryControlPrenatal();
                          },
                          child: const Text('Consultar Datos Guardados'),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _controlPrenatalData.length,
                    itemBuilder: (context, index) {
                      final data = _controlPrenatalData[index];
                      return ListTile(
                        title: Text('Semana: ${data['Semana']}'),
                        subtitle: Text(
                            'Exámenes Clínicos: ${data['Examenes_Clinicos']}, Visitas Ginecológicas: ${data['Visitas_Ginecologicas']}, IMC: ${data['IMC']}, Talla: ${data['Talla']}'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _queryControlPrenatal() async {
    final allRows = await dbHelper.queryAllControlesPrenatales();
    setState(() {
      _controlPrenatalData = allRows;
    });
  }
}
