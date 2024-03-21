import 'package:flutter/material.dart';
import 'package:pmsn2024/database/favorite_movies.dart';
import 'package:pmsn2024/model/popular_model.dart';
import 'package:pmsn2024/network/api_popular.dart';
import 'package:pmsn2024/screens/detIail_movie_screen.dart';
import 'package:pmsn2024/services/favorites_firebase.dart';
import 'package:pmsn2024/widgets/item_movie_widgets.dart';

class FavoriteMoviesScreen extends StatefulWidget {
  const FavoriteMoviesScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteMoviesScreen> createState() => _FavoriteMoviesScreenState();
}

class _FavoriteMoviesScreenState extends State<FavoriteMoviesScreen> {
  ApiPopular? apiPopular;
  bool showFavoritesOnly = false;
  List<PopularModel> favoriteMovies = [];

  @override
  void initState() {
    super.initState();
    apiPopular = ApiPopular();
  }

  void _showFavoriteIds(BuildContext context) {
    final List<String> favoriteIds =
        favoriteMovies.map((movie) => movie.id.toString()).toList();
    final String favoriteIdsString = favoriteIds.join(', ');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('IDs de películas favoritas: $favoriteIdsString'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Movies'),
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
              _showFavoriteIds(context);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: apiPopular!.getPopularMovie(),
        builder: (context, AsyncSnapshot<List<PopularModel>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Ocurrió un error :("),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text("No hay datos"),
            );
          } else {
            final moviesToShow = showFavoritesOnly
                ? snapshot.data!.where((movie) => movie.isFavorite).toList()
                : snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .7,
                mainAxisSpacing: 0,
              ),
              itemCount: moviesToShow.length,
              itemBuilder: (context, index) {
                final movie = moviesToShow[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DetailMovieScreen(
                          movie: movie,
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
          }
        },
      ),
    );
  }
}
