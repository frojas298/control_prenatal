import 'package:flutter/material.dart';
import 'database_helper.dart';

class RegistrationFormPage extends StatefulWidget {
  const RegistrationFormPage({super.key});

  @override
  _RegistrationFormPageState createState() => _RegistrationFormPageState();
}

class _RegistrationFormPageState extends State<RegistrationFormPage> {
  final _formKey = GlobalKey<FormState>();
  final dbHelper = DatabaseHelper();
  String? _nombre;
  DateTime? _fechaNacimiento;
  bool? _primerEmbarazo;
  int? _numeroEmbarazo;
  List<Map<String, dynamic>> _usuariosData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Usuario'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Nombre',
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
                      onSaved: (value) => _nombre = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese un nombre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Fecha de Nacimiento',
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
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            _fechaNacimiento = picked;
                          });
                        }
                      },
                      readOnly: true,
                      controller: TextEditingController(
                        text: _fechaNacimiento != null
                            ? _fechaNacimiento!.toLocal().toString().split(' ')[0]
                            : '',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor seleccione una fecha de nacimiento';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    DropdownButtonFormField<bool>(
                      decoration: InputDecoration(
                        labelText: '¿Es su primer embarazo?',
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
                      value: _primerEmbarazo,
                      items: const [
                        DropdownMenuItem(
                          value: true,
                          child: Text('Sí'),
                        ),
                        DropdownMenuItem(
                          value: false,
                          child: Text('No'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _primerEmbarazo = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor seleccione una opción';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Número de Embarazo',
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
                      onSaved: (value) => _numeroEmbarazo = int.tryParse(value!),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el número de embarazo';
                        }
                        final n = int.tryParse(value);
                        if (n == null) {
                          return 'Por favor ingrese un valor numérico';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            dbHelper.insertUsuario({
                              'Nombre': _nombre,
                              'Fecha_Nacimiento': _fechaNacimiento!.toIso8601String(),
                              'Primer_Embarazo': _primerEmbarazo! ? 1 : 0,
                              'Numero_Embarazo': _numeroEmbarazo
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
                          _queryUsuarios();
                        },
                        child: const Text('Consultar Datos Guardados'),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _usuariosData.length,
                  itemBuilder: (context, index) {
                    final data = _usuariosData[index];
                    return ListTile(
                      title: Text('Nombre: ${data['Nombre']}'),
                      subtitle: Text(
                          'Fecha de Nacimiento: ${data['Fecha_Nacimiento']}, Primer Embarazo: ${data['Primer_Embarazo'] == 1 ? 'Sí' : 'No'}, Número de Embarazo: ${data['Numero_Embarazo']}'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _queryUsuarios() async {
    final allRows = await dbHelper.queryAllUsuarios();
    setState(() {
      _usuariosData = allRows;
    });
  }
}
