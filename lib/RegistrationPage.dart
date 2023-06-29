import 'package:flutter/material.dart';
import 'main.dart';

class RegistrationPage extends StatefulWidget {
  final UserRepository userRepository;

  RegistrationPage({required this.userRepository});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void registerUser() {
    String name = _nameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (name.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error en el registro'),
          content: Text('Rellena todos los campos del registro.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    if (widget.userRepository.isEmailRegistered(email)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error en el registro'),
          content: Text('El email ya ha sido registrado anteriormente.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Validación del formato de correo electrónico
    if (!_isValidEmail(email)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error en el registro'),
          content: Text('Email no valido, insértelo en el formato correcto.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Validación de la contraseña
    if (!_isValidPassword(password)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error en el registro'),
          content: Text(
              'Inserte una contraseña válida. Indicaciones: minimo 5 carácteres, al menos una mayúscula y un número.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    widget.userRepository.registerUser(name, lastName, email, password);

    _nameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _passwordController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Registro completo'),
        content: Text('El registro ha sido formalizado! Inicia sesión y disfruta!.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  bool _isValidEmail(String email) {
    RegExp emailRegex = RegExp(r'^[\w.+-]+@(gmail|hotmail)\.(com|es)$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    RegExp passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*\d).{5,}$');
    return passwordRegex.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Easy List'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logoGrande.png',
                  width: 200,
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Apellidos',
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: registerUser,
                  child: Text('Registrarse'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
