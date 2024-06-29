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
  bool _hemograma = false;
  bool _urocultivo = false;
  bool _vdrl = false;
  bool _hepatitisB = false;
  bool _citologia = false;
  bool _glicemia = false;
  bool _ultrasonido = false;
  bool _ultrasonidoAneuploide = false;
  bool _dopplerUterinas = false;
  bool _ultrasonidoAnatomia = false;
  bool _doppler = false;
  bool _cervix = false;
  bool _glicemiaPost = false;
  bool _coombs = false;
  bool _inmunoglobulina = false;
  bool _ultrasonido3238 = false;
  bool _vdrl3238 = false;
  bool _streptococo = false;
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
        color: Colors.white,
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
                      ..._getCheckBoxesForWeek(),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese las visitas ginecológicas';
                          }
                          return null;
                        },
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
                            return 'Por favor ingrese el IMC';
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
                            return 'Por favor ingrese la talla';
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
                          onPressed: _showConfirmationDialog,
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

  void _showConfirmationDialog() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmar cambios'),
            content: const Text('¿Desea enviar los datos ingresados?'),
            actions: <Widget>[
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Sí'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _submitForm();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _submitForm() {
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

  void _queryControlPrenatal() async {
    final allRows = await dbHelper.queryAllControlesPrenatales();
    setState(() {
      _controlPrenatalData = allRows;
    });
  }

  List<Widget> _getCheckBoxesForWeek() {
    List<Widget> checkBoxes = [];
    switch (widget.weekRange) {
      case '4-8':
        checkBoxes.addAll([
          CheckboxListTile(
            title: const Text('Hemograma/Hto-Hb'),
            value: _hemograma,
            onChanged: (value) {
              setState(() {
                _hemograma = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Urocultivo y Orina Completa'),
            value: _urocultivo,
            onChanged: (value) {
              setState(() {
                _urocultivo = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('VDRL-RPR'),
            value: _vdrl,
            onChanged: (value) {
              setState(() {
                _vdrl = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Ag Superficie Hepatitis B'),
            value: _hepatitisB,
            onChanged: (value) {
              setState(() {
                _hepatitisB = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Citología cervical'),
            value: _citologia,
            onChanged: (value) {
              setState(() {
                _citologia = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Glicemia'),
            value: _glicemia,
            onChanged: (value) {
              setState(() {
                _glicemia = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Ultrasonido por indicación'),
            value: _ultrasonido,
            onChanged: (value) {
              setState(() {
                _ultrasonido = value!;
              });
            },
          ),
        ]);
        break;
      case '11-14':
        checkBoxes.addAll([
          CheckboxListTile(
            title: const Text('Ultrasonido 11 a 14 semanas para riesgo de aneuploidía (más Bioquimica: BHCG libre PAPP-a, según la disponibilidad)'),
            value: _ultrasonidoAneuploide,
            onChanged: (value) {
              setState(() {
                _ultrasonidoAneuploide = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Doppler arterias uterinas'),
            value: _dopplerUterinas,
            onChanged: (value) {
              setState(() {
                _dopplerUterinas = value!;
              });
            },
          ),
        ]);
        break;
      case '20-24':
        checkBoxes.addAll([
          CheckboxListTile(
            title: const Text('Ultrasonido anatomía y marcadores aneuploidía Doppler de arterias uterinas (si no se realizó en examen US previo)'),
            value: _ultrasonidoAnatomia,
            onChanged: (value) {
              setState(() {
                _ultrasonidoAnatomia = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Evaluación del cervix, según disponibilidad'),
            value: _cervix,
            onChanged: (value) {
              setState(() {
                _cervix = value!;
              });
            },
          ),
        ]);
        break;
      case '26-28':
        checkBoxes.addAll([
          CheckboxListTile(
            title: const Text('Glicemia post prandial, tamizaje de diabetes Coombs Indirecto Rh no sensibilizada'),
            value: _glicemiaPost,
            onChanged: (value) {
              setState(() {
                _glicemiaPost = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Administración inmunoglobulina anti Rho (Rh no sensibilizada) segun sensibilidad'),
            value: _inmunoglobulina,
            onChanged: (value) {
              setState(() {
                _inmunoglobulina = value!;
              });
            },
          ),
        ]);
        break;
      case '32-38':
        checkBoxes.addAll([
          CheckboxListTile(
            title: const Text('Ultrasonido'),
            value: _ultrasonido3238,
            onChanged: (value) {
              setState(() {
                _ultrasonido3238 = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Repetir VDRL/RPR, Hcto-Hb'),
            value: _vdrl3238,
            onChanged: (value) {
              setState(() {
                _vdrl3238 = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Cultivo Streptococo B'),
            value: _streptococo,
            onChanged: (value) {
              setState(() {
                _streptococo = value!;
              });
            },
          ),
        ]);
        break;
      default:
        break;
    }
    return checkBoxes;
  }
}
