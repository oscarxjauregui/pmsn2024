import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pmsn2024/model/popular_model.dart';
import 'package:pmsn2024/screens/detIail_movie_screen.dart';

class FavoritesMoviesScreen extends StatelessWidget {
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
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getMoviesData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final List<Map<String, dynamic>> moviesData = snapshot.data ?? [];
            if (moviesData.isEmpty) {
              return Center(
                child: Text('No hay películas agregadas a favoritos'),
              );
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    2, // Cambia esto según el número de columnas que desees
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.7, // Ajusta esto según tus necesidades
              ),
              itemCount: moviesData.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> movieData = moviesData[index];
                final String movieId = movieData['id'];
                final int idx = movieData['idMovie'];
                final String movieTitle = movieData['title'];
                final String posterPath = movieData['posterPath'];
                final String backdropPath = movieData['backdropPath'];
                final String originalLanguage = movieData['originalLanguage'];
                final String originalTitle = movieData['originalTitle'];
                final String overview = movieData['overview'];
                final double popularity = movieData['popularity'];
                final String releaseDate = movieData['releaseDate'];
                final double voteAverage = movieData['voteAverage'];
                final int voteCount = movieData['voteCount'];
                final bool isFavorite = movieData['isFavorite'];

                return GestureDetector(
                  onTap: () {
                    
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DetailMovieScreen(
                          movie: PopularModel(
                            id: idx,
                            backdropPath: backdropPath,
                            originalLanguage: originalLanguage,
                            originalTitle: originalTitle,
                            overview: overview,
                            popularity: popularity,
                            posterPath: posterPath,
                            releaseDate: releaseDate,
                            title: movieTitle,
                            voteAverage: voteAverage,
                            voteCount: voteCount,
                            isFavorite: isFavorite,
                          ),
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: 'moviePoster_$movieId',
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w500/$posterPath',
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getMoviesData() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('favorites').get();
    final List<Map<String, dynamic>> moviesData = [];
    snapshot.docs.forEach((doc) {
      moviesData.add({
        'id': doc.id,
        'idMovie': doc['id'],
        'backdropPath': doc['backdropPath'],
        'originalLanguage': doc['originalLanguage'],
        'originalTitle': doc['originalTitle'],
        'overview': doc['overview'],
        'popularity': doc['popularity'],
        'posterPath': doc['posterPath'],
        'releaseDate': doc['releaseDate'],
        'title': doc['title'],
        'voteAverage': doc['voteAverage'],
        'voteCount': doc['voteCount'],
        'isFavorite': doc['isFavorite'],
      });
    });
    return moviesData; // Devuelve la lista de datos de películas
  }
}
