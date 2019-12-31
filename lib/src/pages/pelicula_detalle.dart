import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ejemplo_conexion_api/src/models/actores_model.dart';
import 'package:flutter_ejemplo_conexion_api/src/models/pelicula_model.dart';
import 'package:flutter_ejemplo_conexion_api/src/providers/peliculas_provider.dart';

/// Esta pagina muestra el detalle de la pelicula seleccionada en la HOME PAGE

class PeliculaDetalle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _crearAppBar(context, pelicula),
          SliverList(
            delegate: SliverChildListDelegate([
              _posterTitulo(context, pelicula),
              _descripcion(pelicula),
              _crearCasting(pelicula),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _crearAppBar(context, Pelicula pelicula) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: AutoSizeText(
            pelicula.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline.copyWith(
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black,
                  offset: Offset(0.0, 0.0),
                ),
              ],
            ),
            maxLines: 3,
          ),
        ),
        background: FadeInImage(
          image: NetworkImage(pelicula.getBackgroundImage()),
          placeholder: AssetImage('assets/img/loading.gif'),
          fadeInDuration: Duration(milliseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitulo(BuildContext context, Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: GestureDetector(
                child: Image.network(
                  pelicula.getPosterImage(),
                  height: 150.0,
                ),
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (_) {
                  //   return DetailPosterScreen(context, pelicula);
                  // }));
                },
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Titulo:',
                    style: Theme.of(context).textTheme.subhead,
                  ),
                  Text(
                    pelicula.title,
                    style: Theme.of(context).textTheme.title,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Titulo original:',
                    style: Theme.of(context).textTheme.subhead,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    pelicula.originalTitle,
                    style: Theme.of(context).textTheme.subhead,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.star_border),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        pelicula.voteAverage.toString(),
                        style: Theme.of(context).textTheme.subhead,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _descripcion(Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _crearCasting(Pelicula pelicula) {
    final peliProvider = new PeliculasProvider();

    return FutureBuilder(
      future: peliProvider.getCast(pelicula.id.toString()),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return _crearActoresPageView(context, snapshot.data);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _crearActoresPageView(context, List<Actor> actores) {
    return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 10.0),
              child: Text(
                'Reparto:',
                style: Theme.of(context).textTheme.subtitle,
              ),
            ),
            SizedBox(
              height: 200.0,
              child: PageView.builder(
                controller: PageController(
                  viewportFraction: 0.3,
                  initialPage: 1,
                ),
                pageSnapping: false,
                itemCount: actores.length,
                itemBuilder: (context, i) {
                  return _tarjetaActor(actores[i]);
                },
              ),
            ),
          ],
        ));
  }

  Widget _tarjetaActor(Actor actor) {
    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage(actor.getActorImage()),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
