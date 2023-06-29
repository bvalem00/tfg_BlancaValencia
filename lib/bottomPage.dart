import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';


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
    final email = emailBot.text;
    final message = mensajeBot.text;
        if (email.isEmpty || message.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Rellena todos los campos para continuar.'),
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
          title: Text('ERROR'),
          content: Text('Inserta un email válido.'),
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

    guardarMensaje(email, message);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enviado!'),
          content: Text('Gracias por ponerte en contacto con nosotros.\nIntentaremos responderle lo antes posible!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );

    emailBot.clear();
    mensajeBot.clear();
  }

  bool emailValido(String email) {
    RegExp emailRegex =
        RegExp(r'^[\w.+-]+@(gmail|hotmail)\.(com|es)$');
    return emailRegex.hasMatch(email);
  }

  Future<void> guardarMensaje(String email, String message) async {
    final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/solicitudes.txt';
  final timestamp = DateTime.now().toString();

    try {
    final file = File(filePath);
    if (!file.existsSync()) {
      file.createSync();
    }
    print('Ruta del archivo: $filePath');
    file.writeAsStringSync('Email: $email\nMensaje: $message\nFecha: $timestamp\n\n', mode: FileMode.append);
  } catch (e) {
    print('Error al guardar el mensaje: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacto'),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/logoGrande.png',
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
                labelText: 'Mensaje',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: formulario,
              child: Text('Enviar'),
            ),
            SizedBox(height: 32.0),
            Text(
              'Información de contacto:',
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