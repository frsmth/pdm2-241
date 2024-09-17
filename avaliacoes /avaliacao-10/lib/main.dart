import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Validação de Formulário: Antonio Abner',
       theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontFamily: 'CherrySwash', // Define a fonte Cherry Swash
            fontSize: 30, // Define o tamanho da fonte
            fontWeight: FontWeight.bold, // Define o peso da fonte
          ),
        ),
      ),
      home: Formulario(),
    );
  }
}

class Formulario extends StatefulWidget {
  @override
  _FormularioState createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _dateController = TextEditingController();
  final _valueController = TextEditingController();

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) return 'Informe uma data';
    try {
      final date = DateFormat('dd-MM-yyyy').parseStrict(value);
      if (date == null) return 'Data inválida';
    } catch (e) {
      return 'Formato inválido. Use dd-MM-aaaa';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Informe um email';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) return 'Email inválido';
    return null;
  }

  String? _validateCPF(String? value) {
    if (value == null || value.isEmpty) return 'Informe o CPF';
    final cpfRegex = RegExp(r'^\d{3}\.\d{3}\.\d{3}\-\d{2}$');
    if (!cpfRegex.hasMatch(value)) return 'CPF no formato xxx.xxx.xxx-xx';
    if (!_isValidCPF(value)) return 'CPF inválido';
    return null;
  }

  bool _isValidCPF(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'[^\d]'), '');

    if (cpf.length != 11 || RegExp(r'^(\d)\1*$').hasMatch(cpf)) return false;

    List<int> numbers = cpf.split('').map(int.parse).toList();
    int sum = 0;

    for (int i = 0; i < 9; i++) sum += numbers[i] * (10 - i);
    int firstCheckDigit = sum % 11 < 2 ? 0 : 11 - (sum % 11);
    if (firstCheckDigit != numbers[9]) return false;

    sum = 0;
    for (int i = 0; i < 10; i++) sum += numbers[i] * (11 - i);
    int secondCheckDigit = sum % 11 < 2 ? 0 : 11 - (sum % 11);
    if (secondCheckDigit != numbers[10]) return false;

    return true;
  }

  String? _validateValue(String? value) {
    if (value == null || value.isEmpty) return 'Informe um valor';
    final valueRegex = RegExp(r'^\d+(\.\d{1,2})?$');
    if (!valueRegex.hasMatch(value)) return 'Valor inválido';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Validação de Formulário: Letícia Vitória'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Data (dd-mm-aaaa)'),
                keyboardType: TextInputType.datetime,
                validator: _validateDate,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              TextFormField(
                controller: _cpfController,
                decoration: InputDecoration(labelText: 'CPF (xxx.xxx.xxx-xx)'),
                keyboardType: TextInputType.number,
                validator: _validateCPF,
              ),
              TextFormField(
                controller: _valueController,
                decoration: InputDecoration(labelText: 'Valor (Ex: 1234.56)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: _validateValue,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Formulário válido!')),
                      );
                    }
                  },
                  child: Text('Enviar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}