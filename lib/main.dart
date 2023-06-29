import 'package:flutter/material.dart';
import 'LoginPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MaterialColor myPrimarySwatch = MaterialColor(
      0xFFF592B3,
      <int, Color>{
        50: Color(0xFFFFE4ED),
        100: Color(0xFFFFBBD0),
        200: Color(0xFFFF8FB4),
        300: Color(0xFFFF6397),
        400: Color(0xFFFF3D81),
        500: Color(0xFFF592B3),
        600: Color(0xFFEE569B),
        700: Color(0xFFE54F8E),
        800: Color(0xFFDD477F),
        900: Color(0xFFD33C6D),
      },
    );

    final ThemeData myTheme = ThemeData(
      primarySwatch: myPrimarySwatch,
      textTheme: ThemeData.light().textTheme.copyWith(
            bodyText2: TextStyle(
              fontFamily: 'Monospace',
              fontSize: 14.0,
            ),
          ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
    UserRepository userRepository = UserRepository();
    return MaterialApp(
      title: 'Easy List',
      theme: myTheme,
      home: LoginPage(userRepository: userRepository),
    );
  }
}

class User {
  final String username;
  final String password;

  User({required this.username, required this.password});
}

class UserRepository {
  List<User> users = [];

  bool isEmailRegistered(String email) {
    return users.any((user) => user.username == email);
  }

  void registerUser(String name, String lastName, String email, String password) {
    User newUser = User(username: email, password: password);
    users.add(newUser);
  }
}
