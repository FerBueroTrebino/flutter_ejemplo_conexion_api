import 'package:flutter/material.dart';
import 'package:flutter_ejemplo_conexion_api/src/models/pelicula_model.dart';
import 'package:flutter_ejemplo_conexion_api/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  String seleccion = '';

  final peliculasProvider = new PeliculasProvider();

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro AppBar (ej: icono para borrar o cancelar busqueda)
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          print('Tab search');
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del appBar (ej: lupa o flecha para buscar)
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
        print('Leading Icon Press');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.red,
        child: Text('seleccion'),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Crea las sugerencias que aparecen cuando se esta escribiendo
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          final peliculas = snapshot.data;
          return ListView(
            children: peliculas.map((pelicula) {
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImage()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: () {
                  close(context, null);
                  pelicula.uniqueId = '';
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                },
              );
            }).toList(),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  /*   @override
  Widget buildSuggestions(BuildContext context) {
    // Crea las sugerencias que aparecen cuando se esta escribiendo
    final listaSugerida = (query.isEmpty)
        ? peliculasRecientes
        : peliculas
            .where(
              (p) => p.toLowerCase().startsWith(query.toLowerCase()),
            )
            .toList();
    return ListView.builder(
      itemCount: listaSugerida.length,
      itemBuilder: (context, i) {
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(listaSugerida[i]),
          onTap: () {
            seleccion = listaSugerida[i];
            showResults(context);
          },
        );
      },
    );
  } */
}
