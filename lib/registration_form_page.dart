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
  bool _primeraVezEmbarazada = false;
  int? _numeroEmbarazos;
  String? _password;
  final TextEditingController _fechaNacimientoController = TextEditingController();

  @override
  void dispose() {
    _fechaNacimientoController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _fechaNacimiento) {
      setState(() {
        _fechaNacimiento = picked;
        _fechaNacimientoController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

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
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
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
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su nombre';
                    }
                    return null;
                  },
                  onSaved: (value) => _nombre = value,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _fechaNacimientoController,
                  decoration: InputDecoration(
                    labelText: 'Fecha de Nacimiento',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _selectDate(context);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su fecha de nacimiento';
                    }
                    if (_fechaNacimiento == null) {
                      return 'Por favor seleccione una fecha válida';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                CheckboxListTile(
                  title: const Text('Primera vez embarazada'),
                  value: _primeraVezEmbarazada,
                  onChanged: (bool? value) {
                    setState(() {
                      _primeraVezEmbarazada = value!;
                      if (_primeraVezEmbarazada) {
                        _numeroEmbarazos = 1;
                      } else {
                        _numeroEmbarazos = null;
                      }
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Número de embarazos',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (!_primeraVezEmbarazada) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el número de embarazos';
                      }
                      final n = num.tryParse(value);
                      if (n == null) {
                        return 'Por favor ingrese un valor numérico';
                      }
                    }
                    return null;
                  },
                  onSaved: (value) => _numeroEmbarazos = _primeraVezEmbarazada ? 1 : int.tryParse(value!),
                  enabled: !_primeraVezEmbarazada,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese una contraseña';
                    }
                    if (value.length < 8) {
                      return 'La contraseña debe tener al menos 8 caracteres';
                    }
                    return null;
                  },
                  onSaved: (value) => _password = value,
                ),
                const SizedBox(height: 16.0),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Registrar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await dbHelper.insertUser({
        'Nombre': _nombre,
        'Fecha_Nacimiento': _fechaNacimiento.toString(),
        'Primer_Embarazo': _primeraVezEmbarazada ? 1 : 0,
        'Numero_Embarazo': _numeroEmbarazos,
        'Password': _password,
      });
      Navigator.pushReplacementNamed(context, '/home', arguments: _nombre);
    }
  }
}
