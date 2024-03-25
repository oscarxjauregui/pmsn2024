import 'package:flutter/material.dart';
import 'package:pmsn2024/database/favorite_movies.dart';
import 'package:pmsn2024/model/popular_model.dart';
import 'package:pmsn2024/network/api_popular.dart';
import 'package:pmsn2024/screens/detIail_movie_screen.dart';
import 'package:pmsn2024/screens/favorite_movies_screen.dart';
import 'package:pmsn2024/services/favorites_firebase.dart';
import 'package:pmsn2024/widgets/item_movie_widgets.dart';

class PopularMoviesScreen extends StatefulWidget {
  const PopularMoviesScreen({super.key});

  @override
  State<PopularMoviesScreen> createState() => _PopularMoviesScreenState();
}

class _PopularMoviesScreenState extends State<PopularMoviesScreen> {
  final favoritesFirebase = FavoritesFirebase();
  ApiPopular? apiPopular;
  bool showFavoritesOnly = false;
  List<PopularModel> favoriteMovies = [];

  @override
  void initState() {
    super.initState();
    apiPopular = ApiPopular();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FavoritesMoviesScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: apiPopular!.getPopularMovie(),
        builder: (context, AsyncSnapshot<List<PopularModel>?> snapshot) {
          //El snapshot trae cada elemento del arreglo (Es una lista del popular model)
          if (snapshot.hasData) {
            final moviesToShow = showFavoritesOnly
                ? snapshot.data!.where((movie) => movie.isFavorite).toList()
                : snapshot.data!;
            return GridView.builder(
              //itemCount: snapshot.data!.length,
              //Se puede poner un .builder a un contenedor cuando no se cauntos elementos hay
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Cambia esto según el número de columnas que desees
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.7,
              ),
              itemCount: moviesToShow.length,
              itemBuilder: (context, index) {
                final movie = moviesToShow[index];
                //final movie = snapshot.data![index];
                return GestureDetector(
                  /*onTap: () => Navigator.pushNamed(context, "/detail",
                      arguments: snapshot.data![index]),*/
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DetailMovieScreen(
                          movie: movie,
                          //favoriteMovies: favoriteMovies,
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: 'moviePoster_${movie.id}',
                    child: itemMovieWidget(movie.posterPath!),
                  ),
                );
              },
            );
          } else {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Ocurrio un error :("),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        },
      ),
    );
  }
}

