import 'package:flutter/material.dart';

class RegistrationFormPage extends StatefulWidget {
  const RegistrationFormPage({super.key});

  @override
  _RegistrationFormPageState createState() => _RegistrationFormPageState();
}

class _RegistrationFormPageState extends State<RegistrationFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  DateTime? _birthDate;
  bool _isFirstTimePregnant = false;
  int _pregnancyCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de Registro'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre'),
                onSaved: (value) => _name = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Fecha de Nacimiento'),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() {
                      _birthDate = date;
                    });
                  }
                },
                readOnly: true,
                controller: TextEditingController(
                  text: _birthDate == null ? '' : _birthDate!.toLocal().toString().split(' ')[0],
                ),
              ),
              SwitchListTile(
                title: const Text('Primera vez embarazada'),
                value: _isFirstTimePregnant,
                onChanged: (bool value) {
                  setState(() {
                    _isFirstTimePregnant = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Número de embarazo'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _pregnancyCount = int.parse(value ?? '0'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Save the data
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
