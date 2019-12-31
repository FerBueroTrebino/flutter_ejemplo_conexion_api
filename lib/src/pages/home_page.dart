import 'package:flutter/material.dart';
import 'package:flutter_ejemplo_conexion_api/src/providers/peliculas_provider.dart';
import 'package:flutter_ejemplo_conexion_api/src/search/search_delegate.dart';
import 'package:flutter_ejemplo_conexion_api/src/widgets/card_swiper_widget.dart';
import 'package:flutter_ejemplo_conexion_api/src/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {
  final peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    peliculasProvider.getPopulares();

    return Scaffold(
      appBar: AppBar(
        title: Text('Peliculas en cines'),
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DataSearch(),
              );
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            _swipeTarjetas(),
            _footerHome(context),
          ],
        ),
      ),
    );
  }

  /// Trae las peliculas que actualmente estan en el cine mediante un FutureBuilder
  ///

  Widget _swipeTarjetas() {
    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.54,
              child: CardSwiper(peliculas: snapshot.data));
        } else {
          return Container(
            height: MediaQuery.of(context).size.height * 0.54,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  /// Trae las peliculas mas populares mediante un StreamBuilder
  ///
  /// Both StreamBuilder and FutureBuilder have the same behavior :
  /// They listen to changes on their respective object. And trigger a new build when
  /// they are notified of a new value. So in the end, their differences is how the
  /// object they listen to works. Future are like Promise in JS or Task in c#

  Widget _footerHome(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child:
                Text('Populares', style: Theme.of(context).textTheme.subhead),
          ),
          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: peliculasProvider.getPopulares,
                );
              } else {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
