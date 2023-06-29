import 'dart:math';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'bottomPage.dart';

class Movie {
  final String name;
  int rating;

  Movie(this.name, {this.rating = 0});

  void setRating(int newRating) {
    rating = newRating;
  }
}

class CollaborativeSystemPage extends StatefulWidget {
  @override
  _CollaborativeSystemPageState createState() => _CollaborativeSystemPageState();
}

class _CollaborativeSystemPageState extends State<CollaborativeSystemPage> {
  List<List<dynamic>> tablaPeliculas = [];
  List<List<dynamic>> tablaValor = [];
  List<String> suggestions = [];
  TextEditingController movieController = TextEditingController();
  List<Movie> selectedMovies = [];
  int numRecommendations = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  @override
  void dispose() {
    movieController.dispose();
    super.dispose();
  }

  Future<void> cargarDatos() async {
    final String moviesData = await rootBundle.loadString('assets/movies.csv');
    final String ratingsData = await rootBundle.loadString('assets/ratings1.csv');
    tablaPeliculas = CsvToListConverter().convert(moviesData);
    tablaValor = CsvToListConverter().convert(ratingsData);
  }

  List<dynamic> buscarFila(String movieName) {
    final int fila = tablaPeliculas.indexWhere(
        (row) => row[1].toString().toLowerCase().contains(movieName.toLowerCase()));
    if (fila != -1) {
      return tablaPeliculas[fila];
    }
    return [];
  }

  List<String> buscarUsuarios(String movieId) {
    final List<String> users = [];
    for (final row in tablaValor) {
      if (row[1].toString() == movieId) {
        final String userId = row[0].toString();
        users.add(userId);
      }
    }
    return users;
  }

  void cuadroPeliculas(BuildContext context) {
    bool noValoradas = selectedMovies.any((movie) => movie.rating == 0);

    if (noValoradas) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Debes valorar todas las películas.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Películas:'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: selectedMovies.map((movie) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Película: ${movie.name}'),
                    Text('Valoración: ${movie.rating}'),
                    SizedBox(height: 8),
                  ],
                );
              }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Modificar'),
              ),
              TextButton(
                onPressed: () async{
                  Navigator.of(context).pop();
                  setState(() {
                    isLoading = true;
                  });
                  await Future.delayed(Duration(seconds: 2));
                  usuariosComun(numRecommendations);
                  setState(() {
                    isLoading = false;
                  });
                },
                child: const Text('Continuar'),
              ),
            ],
          );
        },
      );
    }
  }

  void usuariosComun(int n) {
    final Map<String, int> frecuencia = {};
    for (final movie in selectedMovies) {
      final String movieId = buscarFila(movie.name)[0].toString();
      final List<String> usuarios = buscarUsuarios(movieId);
      for (final usuario in usuarios) {
        frecuencia[usuario] = (frecuencia[usuario] ?? 0) + 1;
      }
    }
    final List<MapEntry<String, int>> listaFrecuencias = frecuencia.entries.toList();
    listaFrecuencias.sort((a, b) => b.value.compareTo(a.value));
    final List<String> usuariosComunes = listaFrecuencias.sublist(0, min(n, listaFrecuencias.length))
        .map((entry) => entry.key)
        .toList();

    final List<Movie> moviesToRecommend = [];
    for (final usuario in usuariosComunes) {
      for (final row in tablaValor) {
        if (row[0].toString() == usuario.toString()) {
          final String movieId = row[1].toString();
          final List<dynamic> movieRow = buscarFila(movieId);
          if (movieRow.isNotEmpty) {
            final String movieName = movieRow[1].toString();
            if (!selectedMovies.any((movie) => movie.name == movieName) &&
                !moviesToRecommend.any((movie) => movie.name == movieName)) {
              moviesToRecommend.add(Movie(movieName));
            }
          }
        }
      }
    }
    mostrarRecomendaciones(moviesToRecommend);
  }

  void mostrarRecomendaciones(List<Movie> movies) {
  if (movies.isEmpty) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No hay recomendaciones'),
          content: const Text('Lo siento, no ha habido recomednaciones disponibles en este momento.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Películas recomendadas:'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: min(movies.length, numRecommendations),
              itemBuilder: (context, index) {
                final movie = movies[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${movie.name}'),
                    SizedBox(height: 8),
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}


  void agregarPelicula() {
    final String movieName = movieController.text.trim();
    if (movieName.isNotEmpty &&
        !selectedMovies.any((movie) => movie.name == movieName)) {
      setState(() {
        selectedMovies.add(Movie(movieName));
        movieController.clear();
      });
    }
  }

  void eliminarPelicula(String movieName) {
    setState(() {
      selectedMovies.removeWhere((movie) => movie.name == movieName);
    });
  }

  void valorarPelicula(Movie movie, int rating) {
    setState(() {
      movie.rating = rating;
    });
  }

  void buscarSugerencias(String prefix) {
    setState(() {
      suggestions = [];
      if (prefix.isNotEmpty) {
        final String lowerCasePrefix = prefix.toLowerCase();
        for (final row in tablaPeliculas) {
          final String movieName = row[1].toString().toLowerCase();
          if (movieName.startsWith(lowerCasePrefix) && !selectedMovies.any((movie) => movie.name == row[1].toString())) {
            suggestions.add(row[1].toString());
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy List'),
      ),
      body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: ListView(
        shrinkWrap: true,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Introduce las películas:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: movieController,
                      onChanged: buscarSugerencias,
                      decoration: InputDecoration(
                        labelText: 'Película',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: agregarPelicula,
                    child: Text('Añadir'),
                  ),
                ],
              ),
              SizedBox(height: 8),
              suggestions.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: suggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = suggestions[index];
                        return ListTile(
                          title: Text(suggestion),
                          onTap: () {
                            setState(() {
                              movieController.text = suggestion;
                              suggestions = [];
                            });
                          },
                        );
                      },
                    )
                  : SizedBox.shrink(),
              SizedBox(height: 16),
              Text(
                'Películas:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Column(
                children: selectedMovies.map((movie) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(movie.name),
                      Wrap(
  spacing: -20, // Ajusta el espacio horizontal entre las estrellas
  runSpacing: 4, // Ajusta el espacio vertical entre las filas de estrellas
  children: [
    IconButton(
      onPressed: () => valorarPelicula(movie, 1),
      iconSize: 20, // Tamaño de las estrellas
      padding: EdgeInsets.zero, // Eliminar el espacio de padding alrededor del icono
      icon: Icon(Icons.star, color: movie.rating >= 1 ? Colors.amber : Colors.grey),
    ),
    IconButton(
      onPressed: () => valorarPelicula(movie, 2),
      iconSize: 20,
      padding: EdgeInsets.zero,
      icon: Icon(Icons.star, color: movie.rating >= 2 ? Colors.amber : Colors.grey),
    ),
    IconButton(
      onPressed: () => valorarPelicula(movie, 3),
      iconSize: 20,
      padding: EdgeInsets.zero,
      icon: Icon(Icons.star, color: movie.rating >= 3 ? Colors.amber : Colors.grey),
    ),
    IconButton(
      onPressed: () => valorarPelicula(movie, 4),
      iconSize: 20,
      padding: EdgeInsets.zero,
      icon: Icon(Icons.star, color: movie.rating >= 4 ? Colors.amber : Colors.grey),
    ),
    IconButton(
      onPressed: () => valorarPelicula(movie, 5),
      iconSize: 20,
      padding: EdgeInsets.zero,
      icon: Icon(Icons.star, color: movie.rating >= 5 ? Colors.amber : Colors.grey),
    ),
    IconButton(
      onPressed: () => eliminarPelicula(movie.name),
      iconSize: 20,
      padding: EdgeInsets.zero,
      icon: Icon(Icons.delete),
    ),
  ],
),

                    ],
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              Text(
                'Introduce el número de recomendaciones que deseas:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          numRecommendations = int.tryParse(value) ?? 1;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'número',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      cuadroPeliculas(context);
                    },
                    child: Text('Recomendación'),
                  ),
                ],
              ),
              isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SizedBox.shrink(),
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
                final String appLink = 'https://easylist.com/collaborative';
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
