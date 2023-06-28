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
          title: Text('Registration failed'),
          content: Text('Please fill in all the required fields.'),
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
          title: Text('Registration failed'),
          content: Text('The email is already registered.'),
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
          title: Text('Registration failed'),
          content: Text('Please enter a valid email.'),
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
          title: Text('Registration failed'),
          content: Text(
              'Please enter a valid password. Indications: minimum 5 characters, at least one capital letter, and one number.'),
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
        title: Text('Registration completed'),
        content: Text('The user has been successfully registered.'),
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
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logoGrande.png',
              width: 200, 
            ),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
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
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: registerUser,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
