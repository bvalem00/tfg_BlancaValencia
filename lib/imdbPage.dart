import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData, FilteringTextInputFormatter, TextInputFormatter, rootBundle;
import 'package:csv/csv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';

import 'HomePage.dart';
import 'bottomPage.dart';
import 'genres.dart';

class imdbPage extends StatefulWidget {
  @override
  imdb createState() => imdb();
}

class imdb extends State<imdbPage> {
  List<List<dynamic>> tablas = [];
  List<String> sugerencia = [];
  TextEditingController controlador = TextEditingController();
  TextEditingController numControlador = TextEditingController();
  List<dynamic> columnasSeleccionadas = [];
  List<String> genresImdb = [...genresI];
  bool reinicio = false;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  @override
  void dispose() {
    controlador.dispose();
    super.dispose();
  }

  Future<void> cargarDatos() async {
    final String datos = await rootBundle.loadString('assets/imdb.csv');
    tablas = CsvToListConverter().convert(datos, fieldDelimiter: ',');
  }

  List<dynamic> buscarFila(String movieName) {
    final int rowIndex = tablas.indexWhere(
        (row) => row[1].toString().toLowerCase().contains(movieName.toLowerCase()));
    if (rowIndex != -1) {
      return tablas[rowIndex];
    }
    return [];
  }

  void recomendaciones(List<dynamic> columnasSeleccionadas, int k, String selectedAlgorithm) {
  final List<Tuple2<double, List<dynamic>>> movieDistance = [];
  for (final row in tablas.skip(1)) {
    double distancia;
    if (selectedAlgorithm == 'Jaccard') {
      distancia = calculoDistanciaJaccard(columnasSeleccionadas, row.sublist(1));
    } else if (selectedAlgorithm == 'Coseno') {
      distancia = calculoDistanciaCoseno(columnasSeleccionadas, row.sublist(1));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Invalid algorithm selected.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }
    movieDistance.add(Tuple2(distancia, row));
  }
  movieDistance.sort((a, b) => a.item1.compareTo(b.item1));
  final List<String> recommendations = movieDistance
      .sublist(0, k + 1)
      .map((tuple) => tuple.item2[1].toString())
      .toList();
  cuadroRecomendaciones(context, recommendations);
}

double calculoDistanciaJaccard(List<dynamic> movie1, List<dynamic> movie2) {
    String director1 = movie1[9].toString();
    String director2 = movie2[9].toString();
    String star1 = movie1[10].toString();
    String star2 = movie2[10].toString();
    String star3 = movie1[11].toString();
    String star4 = movie2[11].toString();
    String star5 = movie1[12].toString();
    String star6 = movie2[12].toString();
    String star7 = movie1[13].toString();
    String star8 = movie2[13].toString();
    String genre1 = movie1[5].toString();
    String genre2 = movie2[5].toString();

    // Normalización de los atributos
    director1 = director1.toLowerCase();
    director2 = director2.toLowerCase();
    star1 = star1.toLowerCase();
    star2 = star2.toLowerCase();
    star3 = star3.toLowerCase();
    star4 = star4.toLowerCase();
    star5 = star5.toLowerCase();
    star6 = star6.toLowerCase();
    star7 = star7.toLowerCase();
    star8 = star8.toLowerCase();
    genre1 = genre1.toLowerCase();
    genre2 = genre2.toLowerCase();

    //Distancia de Jaccard
    double directorDistancia = calculoJaccard(director1, director2);
    double castDistancia = calculoJaccard(star1, star2);
    double castDistancia2 = calculoJaccard(star3, star4);
    double castDistancia3 = calculoJaccard(star5, star6);
    double castDistancia4 = calculoJaccard(star7, star8);
    double listed_inDistancia = calculoJaccard(genre1, genre2);

    // Ajuste de los pesos
    final double directorPeso = 1.0;
    final double castPeso = 0.5;
    final double genrePeso = 0.5;

    // Cálculo de la distancia
    final double distancia = (directorDistancia * directorPeso) +
        (castDistancia * castPeso) +
        (castDistancia2 * castPeso) +
        (castDistancia3 * castPeso) +
        (castDistancia4 * castPeso) +
        (listed_inDistancia * genrePeso);

    return distancia;
  }

  double calculoJaccard(String attributo1, String attributo2) {
    final Set<String> tokens1 = attributo1.split(' ').toSet();
    final Set<String> tokens2 = attributo2.split(' ').toSet();
    final double intersection = tokens1.intersection(tokens2).length.toDouble();
    final double union = tokens1.union(tokens2).length.toDouble();
    return 1 - (intersection / union);
  }

  double calculoDistanciaCoseno(List<dynamic> movie1, List<dynamic> movie2) {
    String director1 = movie1[9].toString();
    String director2 = movie2[9].toString();
    String star1 = movie1[10].toString();
    String star2 = movie2[10].toString();
    String star3 = movie1[11].toString();
    String star4 = movie2[11].toString();
    String star5 = movie1[12].toString();
    String star6 = movie2[12].toString();
    String star7 = movie1[13].toString();
    String star8 = movie2[13].toString();
    String genre1 = movie1[5].toString();
    String genre2 = movie2[5].toString();

    // Normalización de los atributos
    director1 = director1.toLowerCase();
    director2 = director2.toLowerCase();
    star1 = star1.toLowerCase();
    star2 = star2.toLowerCase();
    star3 = star3.toLowerCase();
    star4 = star4.toLowerCase();
    star5 = star5.toLowerCase();
    star6 = star6.toLowerCase();
    star7 = star7.toLowerCase();
    star8 = star8.toLowerCase();
    genre1 = genre1.toLowerCase();
    genre2 = genre2.toLowerCase();

    // Distancia del coseno
    double directorDistancia = calculoJaccard(director1, director2);
    double castDistancia = calculoJaccard(star1, star2);
    double castDistancia2 = calculoJaccard(star3, star4);
    double castDistancia3 = calculoJaccard(star5, star6);
    double castDistancia4 = calculoJaccard(star7, star8);
    double listed_inDistancia = calculoJaccard(genre1, genre2);

    // Ajuste de los pesos
    final double directorPeso = 1.0;
    final double castPeso = 0.5;
    final double genrePeso = 0.5;

    // Cálculo de la distancia
    final double distancia = (directorDistancia * directorPeso) +
        (castDistancia * castPeso) +
        (castDistancia2 * castPeso) +
        (castDistancia3 * castPeso) +
        (castDistancia4 * castPeso) +
        (listed_inDistancia * genrePeso);

    return distancia;
  }

  double calculoCoseno(String atributo1, String atributo2) {
  final List<String> tokens1 = atributo1.split(' ');
  final List<String> tokens2 = atributo2.split(' ');

  final Set<String> uniqueTokens = Set<String>.from([...tokens1, ...tokens2]);
  final Map<String, int> vector1 = {};
  final Map<String, int> vector2 = {};

  for (final token in tokens1) {
    vector1[token] = (vector1[token] ?? 0) + 1;
  }

  for (final token in tokens2) {
    vector2[token] = (vector2[token] ?? 0) + 1;
  }

  double dotProduct = 0;
  double magnitude1 = 0;
  double magnitude2 = 0;

  for (final token in uniqueTokens) {
    dotProduct += (vector1[token] ?? 0) * (vector2[token] ?? 0);
    magnitude1 += (vector1[token] ?? 0) * (vector1[token] ?? 0);
    magnitude2 += (vector2[token] ?? 0) * (vector2[token] ?? 0);
  }

  magnitude1 = sqrt(magnitude1);
  magnitude2 = sqrt(magnitude2);

  if (magnitude1 == 0 || magnitude2 == 0) {
    return 0; // Evitar división por cero
  }

  final double cosineSimilarity = dotProduct / (magnitude1 * magnitude2);
  return 1 - cosineSimilarity; // Convertir similaridad en distancia
}

  void cuadroRecomendaciones(BuildContext context, List<String> recommendations) {
    if (reinicio) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomePage()),
        (Route<dynamic> route) => false,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Recommendations:'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: recommendations.map((recommendation) => Text(recommendation)).toList(),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final String enlaceImdb = 'https://www.imdb.com/';
                launch(enlaceImdb);
              },
              child: const Text('Go to IMDB'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (Route<dynamic> ruta) => false,
                );
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void cuadroPeliculas(BuildContext context) {
    showDialog(
    context: context,
    builder: (BuildContext context) {
      String selectedAlgorithm = 'Jaccard'; // Algoritmo seleccionado (valor predeterminado: Jaccard)

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Details:'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Title: ' + columnasSeleccionadas[1].toString()),
                Text('Director: ' + columnasSeleccionadas[9].toString()),
                Text('Cast: ' + columnasSeleccionadas[10].toString() + ", " +columnasSeleccionadas[11].toString() + ", " +columnasSeleccionadas[12].toString() + ", " +columnasSeleccionadas[13].toString()),
                Text('Release year: ' + columnasSeleccionadas[2].toString()),
                Text('Genre: ' + columnasSeleccionadas[5].toString()),
                Text('Description: '+ columnasSeleccionadas[7].toString()),
                TextField(
                  controller: numControlador,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Enter the number of recommendations',
                  ),
                ),
                SizedBox(height: 30),
                Text('Select an algoritm to continue:'),
                DropdownButton<String>(
                  value: selectedAlgorithm,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedAlgorithm = newValue!;
                    });
                  },
                  items: <String>['Jaccard', 'Coseno'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    controlador.clear();
                    columnasSeleccionadas = [];
                  });
                },
                child: const Text('Modify'),
              ),
              TextButton(
                onPressed: () {
                  if (selectedAlgorithm == 'Jaccard' || selectedAlgorithm == 'Coseno') {
                    if (numControlador.text.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('Please enter the number of recommendations.'),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      Navigator.of(context).pop();
                      int numRecomendaciones = int.parse(numControlador.text);
                      recomendaciones(columnasSeleccionadas, numRecomendaciones, selectedAlgorithm);
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text('Please select an algorithm.'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('Continue'),
              ),
            ],
          );
        },
      );
    },
  );
}

List <dynamic> getMoviesByGenre(String genre) {
    return tablas.where((row) => row[5].toString().toLowerCase().contains(genre.toLowerCase())).toList();
  }

  List<dynamic> getMoviesByType(String type) {
    return tablas.where((row) => row[3].toString().toLowerCase().contains(type.toLowerCase())).toList();
  }

  Widget buildGenreSection(String genre) {
    final List<dynamic> moviesG = getMoviesByGenre(genre);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            genre,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 245, 146, 179),
            ),
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: moviesG.length,
            itemBuilder: (context, index) {
              final movie = moviesG[index];
              final movieName = movie[1].toString();
              return GestureDetector(
                onTap: () {
                  setState(() {
                    controlador.text = movieName;
                    columnasSeleccionadas = movie;
                  });
                  cuadroPeliculas(context);
                },
                child: Container(
                  width: 120,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Expanded(
                       child: genreImagesI.containsKey(genre)
                          ? Image.asset(
                              genreImagesI[genre]!,
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.image),
                      ),
                      SizedBox(height: 4),
                      Text(
                        movieName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IMDB',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/logoGrande.png',
                width: 100,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/logoTrans.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/imdb.png',
                      width: 100,
                      height: 60,
                    ),
                    SizedBox(height: 0),
                      Text(
                      '"IMDb, Internet Movie Database (Base de Datos de películas en Internet) es la base de datos de películas más grande y completa de la web que almacena información relacionada con películas, personal del equipo de producción, directores, actores... que aparecen en los medios de entretenimiento visual. Considerado como uno de los sitios más importantes de cine y televisión, IMDb, originalmente, fue construida por Col Needham, Dave Knight y Andy Krieg un 17 de octubre de 1985, pero nació oficialmente en 1990, y en 1998 fue adquirida por Amazon."',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: controlador,
                      onChanged: (value) {
                        setState(() {
                          sugerencia = tablas
                              .skip(1)
                              .where((row) =>
                                  row[1].toString().toLowerCase().contains(value.toLowerCase()))
                              .map((row) => row[1].toString())
                              .toList();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Movie name',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        controlador.clear();
                        sugerencia = [];
                        columnasSeleccionadas = [];
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              if (sugerencia.isNotEmpty)
                Container(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: sugerencia.length,
                    itemBuilder: (context, index) {
                      final suggestion = sugerencia[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            controlador.text = suggestion;
                            columnasSeleccionadas = buscarFila(suggestion);
                          });
                          cuadroPeliculas(context);
                        },
                        child: Container(
                          width: 120,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.asset(
                                  'assets/logoTrans.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                suggestion,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
           SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: genresImdb.length,
                  itemBuilder: (context, index) {
                    final genre = genresImdb[index];
                    return buildGenreSection(genre);
                  },
                ),
              ),
            ],
          ),
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
                final String appLink = 'https://example.com/app-link'; // Reemplazar
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