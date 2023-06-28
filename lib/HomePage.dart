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
              width: 200,
            ),
            SizedBox(height: 0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Text(
                'Sistema de Recomendación',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  decoration: TextDecoration.underline,
                  decorationColor: const Color.fromARGB(255, 245, 146, 179),
                  decorationThickness: 2.0, 
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '\n\n¿En que consisten los diferentes filtrados?\nPulsa sobre ellos para saber más!',
                style: TextStyle(
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Filtrado colaborativo'),
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
                        'FILTRADO COLABORATIVO',
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
                          title: Text('Filtrado basado en contenido'),
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
                        'assets/filtradoBasado.png',
                        width: 90,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'FILTRADO BASADO EN CONTENIDO',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '\n\n¿Quieres saber más sobre los algoritmos con los que trabajamos?\nPulsa sobre ellos para saber más!',
                style: TextStyle(
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Correlación de Pearson'),
                          content: Text(
                            'Algoritmo utilizado para el "Filtrado colaborativo".\nLa correlación de Pearson es una medida' 
                            + 'estadística que evalúa la relación lineal entre dos variables. En el contexto de los sistemas de recomendación, se utiliza para determinar la similitud entre dos conjuntos de datos,' 
                            + 'como por ejemplo las calificaciones que los usuarios han dado a diferentes elementos.'
                            + '\nLa correlación de Pearson toma valores entre -1 y 1, donde 1 indica una correlación positiva perfecta, -1 indica una correlación negativa perfecta y 0 indica ausencia de correlación. Un valor cercano a 1 significa que dos' 
                            + 'variables están altamente correlacionadas, lo que implica que si a un usuario le gusta un elemento, es probable que también le guste otro elemento con alta correlación.'
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
                        'assets/algoritmos.jpeg',
                        width: 110,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'CORRELACIÓN DE PEARSON',
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
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Algoritmo de Jaccard'),
                          content: Text(
                            'Algoritmo utilizado para el "Filtrado basado en contenido".\nEl algoritmo de Jaccard es un método utilizado para calcular la similitud entre conjuntos. En el contexto de los sistemas de recomendación, se utiliza para determinar la similitud entre los conjuntos de elementos' 
                            + 'que han sido valorados o seleccionados por diferentes usuarios.\nEl algoritmo de Jaccard calcula la similitud dividiendo el número de elementos comunes entre dos conjuntos por el número total de elementos '
                            + 'en ambos conjuntos. El resultado varía entre 0 y 1, donde 0 indica que los conjuntos no tienen elementos en común y 1 indica que los conjuntos son idénticos.'
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
                        'assets/jaccard.png',
                        width: 110,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'JACCARD',
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
                          title: Text('Algoritmo del Coseno'),
                          content: Text(
                            'Algoritmo utilizado para el "Filtrado basado en contenido".\nEl algoritmo del coseno es un método utilizado para calcular la similitud entre dos vectores en un espacio vectorial. En el contexto de los sistemas de recomendación, se utiliza para determinar la similitud entre los perfiles' 
                            + 'de preferencias de los usuarios o las características de los elementos.\nEl algoritmo del coseno calcula la similitud entre dos vectores dividiendo el producto escalar de los vectores por el producto de sus magnitudes. El resultado varía entre -1 y 1, '
                            + 'donde 1 indica una similitud perfecta en la misma dirección, -1 indica una similitud perfecta en direcciones opuestas y 0 indica que los vectores son ortogonales o no tienen similitud.'
                            + 'La carrelación de pearson es el único  utilizado en esa sección, en cambio en el filtrado basado en contenido'
                            + ' podrás elegir entre jaccard o coseno para realizar la recomendación. No esperes más y pruébalos!'
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
                        'assets/coseno.png',
                        width: 70,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'COSENO',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: Colors.black,
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



