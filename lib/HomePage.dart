import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData, FontWeight, TextAlign;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';

import 'AmazonPage.dart';
import 'CollaborativeSystemPage.dart';
import 'DisneyPage.dart';
import 'NetflixPage.dart';
import 'bottomPage.dart';
import 'hboPage.dart';
import 'imdbPage.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text(
                'Menu',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 245, 146, 179),
              ),
            ),
            ListTile(
              title: Text('Collaborative System', 
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CollaborativeSystemPage()),
                );
              },
            ),
            ExpansionTile(
              title: Text(
                'Content-Based Filtering',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              children: [
                ListTile(
                  title: Text(
                    'Netflix',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Color.fromARGB(255, 87, 84, 85),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NetflixPage()),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    'Disney Plus',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Color.fromARGB(255, 87, 84, 85),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DisneyPage()),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    'Prime Video',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Color.fromARGB(255, 87, 84, 85),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AmazonPage()),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    'HBO',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Color.fromARGB(255, 87, 84, 85),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => hboPage()),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    'IMDB',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Color.fromARGB(255, 87, 84, 85),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => imdbPage()),
                    );
                  },
                ),
              ],
            ),

            Divider(),
            ListTile(
              title: Text('Salir',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 0),
            Image.asset(
              'assets/logoN.png',
              width: 350,
            ),
            SizedBox(height: 0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Sistema de Recomendación',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  decoration: TextDecoration.underline,
                  decorationColor: const Color.fromARGB(255, 245, 146, 179),
                  decorationThickness: 2.0, 
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Un sistema de recomendación es una herramienta que analiza los datos de los usuarios y utiliza algoritmos para ofrecer sugerencias personalizadas. Su objetivo es ayudar a los '
                +'usuarios a descubrir nuevos elementos, como productos, servicios o contenido, que puedan interesarles, basándose en sus preferencias y comportamientos anteriores.',
                style: TextStyle(
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Collaborative System'),
                          content: Text(
                            'El filtrado colaborativo es un enfoque utilizado por los sistemas de recomendación para hacer predicciones y sugerencias en función de las '
                            +'opiniones e interacciones de un grupo de usuarios. En lugar de analizar características individuales, este método busca patrones y similitudes '
                            'entre diferentes usuarios para identificar recomendaciones relevantes. Por ejemplo, si dos usuarios tienen gustos similares y uno de ellos ha encontrado algo que le gusta, es probable que al otro usuario también le guste.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cerrar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/collaborative.jpeg',
                        width: 100,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Collaborative System',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Content-Based Filtering'),
                          content: Text(
                            'El filtrado basado en contenido es un método utilizado por los sistemas de recomendación para ofrecer sugerencias personalizadas en función'
                            +'de las características y propiedades de los elementos a recomendar. Estos sistemas analizan el contenido de los elementos previamente valorados' 
                            +'por el usuario y buscan otros elementos con características similares. Por ejemplo, si un usuario ha disfrutado de películas de ciencia ficción en el pasado, el sistema de recomendación puede sugerirle otras películas del mismo género.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cerrar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/content.jpeg',
                        width: 100,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Content-Based Filtering',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.black, // Cambia el color del texto a negro
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: FaIcon(FontAwesomeIcons.instagram,
                color: const Color.fromARGB(255, 245, 146, 179),
              ),
              onPressed: () {
                // Acción al presionar el botón de Twitter
              },
            ),
            IconButton(
              icon: FaIcon(FontAwesomeIcons.twitter,
                color: const Color.fromARGB(255, 245, 146, 179),
              ),
              onPressed: () {
                // Acción al presionar el botón de Instagram
              },
            ),
            IconButton(
              icon: Icon(Icons.share,
                color: const Color.fromARGB(255, 245, 146, 179),
              ),
              onPressed: () {
                final String appLink = 'https://easylist.com'; // Reemplazar
                Clipboard.setData(ClipboardData(text: appLink)).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Enlace copiado')),
                  );
                });
                Share.share(appLink);
              },
            ),
            InkWell(
              onTap: () {
                // Acción al presionar el enlace de preguntas frecuentes
              },
              child: Text(
                'FAQ',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: const Color.fromARGB(255, 245, 146, 179),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => contactar()),
                    );
              },
              child: Text(
                'Contactar',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: const Color.fromARGB(255, 245, 146, 179),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



