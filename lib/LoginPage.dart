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
          title: Text('Failed login'),
          content: Text('The username or password is incorrect.'),
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
        title: Text('Login'),
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
            SizedBox(height: 16.0),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
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
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: loginUser,
              child: Text('Login'),
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
      ),
    );
  }
}
