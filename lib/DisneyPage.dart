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

class DisneyPage extends StatefulWidget {
  @override
  disney createState() => disney();
}

class disney extends State<DisneyPage> {
  List<List<dynamic>> tablas = [];
  List<String> sugerencia = [];
  TextEditingController controlador = TextEditingController();
  TextEditingController numControlador = TextEditingController();
  List<dynamic> columnasSeleccionadas = [];
  List<String> genresDisney = [...genresD];
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
    final String datos = await rootBundle.loadString('assets/disney.csv');
    tablas = CsvToListConverter().convert(datos, fieldDelimiter: ',');
  }

  List<dynamic> buscarFila(String movieName) {
    final int rowIndex = tablas.indexWhere(
        (row) => row[2].toString().toLowerCase().contains(movieName.toLowerCase()));
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
            content: const Text('No ha seleccionado ningún algoritmo.'),
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
      .map((tuple) => tuple.item2[2].toString())
      .toList();
  cuadroRecomendaciones(context, recommendations);
}


  double calculoDistanciaJaccard(List<dynamic> movie1, List<dynamic> movie2) {
    String director1 = movie1[3].toString();
    String director2 = movie2[3].toString();
    String cast1 = movie1[4].toString();
    String cast2 = movie2[4].toString();
    String listed_in1 = movie1[10].toString();
    String listed_in2 = movie2[10].toString();


    // Normalización de los atributos
    director1 = director1.toLowerCase();
    director2 = director2.toLowerCase();
    cast1 = cast1.toLowerCase();
    cast2 = cast2.toLowerCase();
    listed_in1 = listed_in1.toLowerCase();
    listed_in2 = listed_in2.toLowerCase();

    //Distancia de Jaccard
    double directorDistancia = calculoJaccard(director1, director2);
    double castDistancia = calculoJaccard(cast1, cast2);
    double listed_inDistancia = calculoJaccard(listed_in1, listed_in2);

    // Ajuste de los pesos
    final double directorPeso = 1.0;
    final double castPeso = 0.5;
    final double listed_inPeso = 0.5;

    // Cálculo de la distancia
    final double distancia = (directorDistancia * directorPeso) +
        (castDistancia * castPeso) +
        (listed_inDistancia * listed_inPeso);

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
    String director1 = movie1[3].toString();
    String director2 = movie2[3].toString();
    String cast1 = movie1[4].toString();
    String cast2 = movie2[4].toString();
    String listed_in1 = movie1[10].toString();
    String listed_in2 = movie2[10].toString();

    // Normalización de los atributos
    director1 = director1.toLowerCase();
    director2 = director2.toLowerCase();
    cast1 = cast1.toLowerCase();
    cast2 = cast2.toLowerCase();
    listed_in1 = listed_in1.toLowerCase();
    listed_in2 = listed_in2.toLowerCase();

    // Distancia del coseno
    final double directorDistancia = calculoCoseno(director1, director2);
    final double castDistancia = calculoCoseno(cast1, cast2);
    final double listed_inDistancia = calculoCoseno(listed_in1, listed_in2);

    // Ajuste de los pesos
    final double directorPeso = 1.0;
    final double castPeso = 0.5;
    final double listed_inPeso = 0.5;

    // Cálculo de la distancia
    final double distancia = (directorDistancia * directorPeso) +
        (castDistancia * castPeso) +
        (listed_inDistancia * listed_inPeso);

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
    return 0;
  }

  final double cosineSimilarity = dotProduct / (magnitude1 * magnitude2);
  return 1 - cosineSimilarity;
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
          title: const Text('Recomendaciones:'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: recommendations.map((recommendation) => Text(recommendation)).toList(),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final String enlaceDisney = 'https://www.disneyplus.com/';
                launch(enlaceDisney);
              },
              child: const Text('Ir a Disney'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (Route<dynamic> ruta) => false,
                );
              },
              child: const Text('Cerrar'),
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
      String selectedAlgorithm = 'Jaccard';

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Detalles:'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(columnasSeleccionadas[1].toString()),
                  Text('Titulo: ' + columnasSeleccionadas[2].toString()),
                  Text('Director: ' + columnasSeleccionadas[3].toString()),
                  Text('Actores: ' + columnasSeleccionadas[4].toString()),
                  Text('País: ' + columnasSeleccionadas[5].toString()),
                  Text('Año añadido en la plataforma: ' + columnasSeleccionadas[6].toString()),
                  Text('Lanzamiento: ' + columnasSeleccionadas[7].toString()),
                  Text('Genero: ' + columnasSeleccionadas[10].toString()),
                  Text('Descripción: ' + columnasSeleccionadas[11].toString()+'\n\n'),
                  TextField(
                    controller: numControlador,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'Número de recomendaciones que deseas:',
                    ),
                  ),
                  SizedBox(height: 30),
                  Text('Selecciona un algoritmo para continuar:'),
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
                child: const Text('Modificar'),
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
                            content: const Text('Por favor, inserta el número de recomendaciones.'),
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
                          content: const Text('Por favor, selecciona un algoritmo.'),
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
                child: const Text('Continuar'),
              ),
            ],
          );
        },
      );
    },
  );
}

  List<dynamic> getMoviesByGenre(String genre) {
    return tablas.where((row) => row[10].toString().toLowerCase().contains(genre.toLowerCase())).toList();
  }

  List<dynamic> getMoviesByType(String type) {
    return tablas.where((row) => row[1].toString().toLowerCase().contains(type.toLowerCase())).toList();
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
              final movieName = movie[2].toString();
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
                       child: genreImagesD.containsKey(genre)
                          ? Image.asset(
                              genreImagesD[genre]!,
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
      title: const Text('Easy List',
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
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                children: [
                  Image.asset(
                    'assets/disney.jpeg',
                    width: 100,
                    height: 60,
                  ),
                  SizedBox(height: 0),
                  Text(
                    '"Es un servicio de Streaming de video operado bajo demanda, es decir, el usuario escoge lo que desea ver desde un repertorio o catálogo en línea. Fue creado y desarrollado por la división de `Media and Entertainment Distribution`, propiedad de The `Walt Disney Company`. Este se centra principalmente en la transmisión de películas y series originales de la cadena, además de otras marcas de la misma. Entre las que se encuentran Marvel, Pixar, Star Wars, Disney y National Geographic."',
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
              children: [
                Expanded(
                  child: TextField(
                    controller: controlador,
                    onChanged: (value) {
                      setState(() {
                        sugerencia = tablas
                            .skip(1)
                            .where((row) =>
                                row[2].toString().toLowerCase().contains(value.toLowerCase()))
                            .map((row) => row[2].toString())
                            .toList();
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Película',
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
                itemCount: genresDisney.length,
                itemBuilder: (context, index) {
                  final genre = genresDisney[index];
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
                //botón de Twitter
              },
            ),
            IconButton(
              icon: FaIcon(FontAwesomeIcons.twitter,
                color: const Color.fromARGB(255, 245, 146, 179),
              ),
              onPressed: () {
                //botón de Instagram
              },
            ),
            IconButton(
              icon: Icon(Icons.share,
                color: const Color.fromARGB(255, 245, 146, 179),
              ),
              onPressed: () {
                final String appLink = 'https://easylist.com/disney';
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
                //enlace preguntas frecuentes
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