import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class contactar extends StatefulWidget{
  @override
  contactarPage createState() => contactarPage();
}

class contactarPage extends State<contactar> {
  final TextEditingController emailBot = TextEditingController();
  final TextEditingController mensajeBot = TextEditingController();

  @override
  void dispose() {
    emailBot.dispose();
    mensajeBot.dispose();
    super.dispose();
  }

  void formulario() {
    // Lógica para enviar el formulario de contacto
    final email = emailBot.text;
    final message = mensajeBot.text;
    // Realizar acciones como enviar el correo electrónico o almacenar el mensaje
        if (email.isEmpty || message.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('You need to fill all the gaps to send the application.'),
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

    if (!emailValido(email)) {
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
    // Mostrar un mensaje de confirmación
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Send'),
          content: Text('Thank you for contacting us. We will try to answer you as soon as possible!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Acept'),
            ),
          ],
        );
      },
    );

    // Limpiar los campos del formulario
    emailBot.clear();
    mensajeBot.clear();
  }

  bool emailValido(String email) {
    RegExp emailRegex =
        RegExp(r'^[\w.+-]+@(gmail|hotmail)\.(com|es)$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact'),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/logoGrande.png', // Ruta del logo de la aplicación
              width: 30,),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: emailBot,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: mensajeBot,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Menssage',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: formulario,
              child: Text('Send'),
            ),
            SizedBox(height: 32.0),
            Text(
              'Contact Information:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text('Email: info@easylist.com'),
            Text('Teléfono: +34 612 123 123'),
          ],
        ),
      ),
    );
  }
}