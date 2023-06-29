import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'RegistrationPage.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  final UserRepository userRepository;

  LoginPage({required this.userRepository});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void registerUser() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationPage(userRepository: widget.userRepository)),
    );
  }

  void loginUser() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    bool userExists = widget.userRepository.users.any((user) => user.username == username && user.password == password);

    if (userExists) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error de inicio de sesión'),
          content: Text('El usuario y/o la contraseña son incorrectos.'),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Usuario',
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
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: loginUser,
                  child: Text('Iniciar sesión'),
                ),
                SizedBox(height: 16.0),
                Text(
                  '© 2023 Easy List',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
