import 'dart:html';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:pmsn2024/model/popular_model.dart';
import 'package:pmsn2024/model/session_model.dart';
import 'package:pmsn2024/network/api_cast.dart';
import 'package:pmsn2024/network/trailer.dart';
import 'package:pmsn2024/services/favorites_firebase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailMovieScreen extends StatefulWidget {
  final PopularModel movie;

  DetailMovieScreen({required this.movie});

  @override
  State<DetailMovieScreen> createState() => _DetailMovieScreenState();
}

class _DetailMovieScreenState extends State<DetailMovieScreen> {
  String? trailerKey;
  List<Map<String, dynamic>> cast = [];
  bool isFavorite = false;
  bool isFavoriteColor = false;
  final FavoritesFirebase favoritesFirebase = FavoritesFirebase();
  late String firebaseId; // Variable para almacenar el ID de Firebase
  String? idx;

  @override
  void initState() {
    super.initState();
    // Obtener el ID de Firebase al inicio del widget
    _getMoviesData().then((moviesData) {
      final movieData = moviesData.firstWhere(
        (data) => data['title'] == widget.movie.title,
        orElse: () => {'id': null},
      );
      setState(() {
        idx = movieData['id'];
        print('id: $idx');
      });
    });
    ApiTrailer().getTrailerVideoKey(widget.movie.id!).then((key) {
      setState(() {
        trailerKey = key;
      });
    });
    ApiCast().getCast(widget.movie.id!).then((actors) {
      setState(() {
        cast = actors!;
      });
    });
    _checkIsFavorite();
    _loadFavoriteColor();
  }

  void _checkIsFavorite() {
    favoritesFirebase.consultar().listen((snapshot) {
      final documents = snapshot.docs;
      final isMovieFavorite =
          documents.any((doc) => doc['id'] == widget.movie.id);
      setState(() {
        isFavorite = isMovieFavorite;
      });
    });
  }

  void _loadFavoriteColor() async {
    SharedPreferences perfs = await SharedPreferences.getInstance();
    bool isRed = perfs.getBool('favorite_color_${widget.movie.id}') ?? false;
    setState(() {
      isFavoriteColor = isRed;
    });
  }

  void _saveFavoriteColor(bool isRed) async {
    SharedPreferences perfs = await SharedPreferences.getInstance();
    await perfs.setBool('favorite_color_${widget.movie.id}', isRed);
  }

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;

      if (isFavorite) {
        _addToFavorites();
        _saveFavoriteColor(true);
      } else {
        _removeFromFavorites();
        _saveFavoriteColor(false);
      }
    });
  }

  void _addToFavorites() {
    widget.movie.isFavorite = true;
    favoritesFirebase.insertar({
      'id': widget.movie.id,
      'backdropPath': widget.movie.backdropPath,
      'originalLanguage': widget.movie.originalLanguage,
      'originalTitle': widget.movie.originalTitle,
      'overview': widget.movie.overview,
      'popularity': widget.movie.popularity,
      'posterPath': widget.movie.posterPath,
      'releaseDate': widget.movie.releaseDate,
      'title': widget.movie.title,
      'voteAverage': widget.movie.voteAverage,
      'voteCount': widget.movie.voteCount,
      'isFavorite': widget.movie.isFavorite,
      // Agrega otros campos que desees guardar
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Se agregó a favoritos: ${widget.movie.title}',
          ),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  void _removeFromFavorites() {
    widget.movie.isFavorite = false;
    favoritesFirebase.eliminar(idx ?? '').then((_) {
      setState(() {
        isFavorite = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Se eliminó de favoritos: ${widget.movie.title}',
          ),
          duration: Duration(seconds: 2),
        ),
      );
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushNamed(context, '/movies');
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al eliminar de favoritos: ${widget.movie.title}',
          ),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  Color _getIconColor(bool favorites) {
    return favorites ? Colors.red : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    String? sessionId = SessionManager().getSessionId();
    final voteAverage = widget.movie.voteAverage;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.movie.title!,
          style: TextStyle(
            color: Colors.black,
            fontStyle: FontStyle.normal,
            //fontSize: 25.0,
            decoration: TextDecoration.none,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Hero(
              tag: 'moviePoster_${widget.movie.id}',
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://image.tmdb.org/t/p/w500/${widget.movie.posterPath}'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(color: Colors.black.withOpacity(0.3)),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 220, // Ancho de la imagen
                      height: 300,
                      padding: EdgeInsets.only(left: 15), // Alto de la imagen
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500/${widget.movie.posterPath}',
                        //fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 10), // Espacio entre la imagen y el texto
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(right: 15.0),
                            child: Text(
                              widget.movie.overview!,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0,
                                decoration: TextDecoration.none,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Center(
                  child: RatingStars(
                    value: voteAverage!,
                    starCount: 10,
                    starSize: 18,
                    valueLabelVisibility: true,
                    valueLabelRadius: 10,
                    maxValue: 10,
                    starSpacing: 2,
                    starColor: Colors.yellow,
                    valueLabelColor: Colors.grey,
                    valueLabelTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.normal,
                      fontSize: 12.0,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                if (trailerKey != null)
                  Center(
                    child: SizedBox(
                      height: 180,
                      width: 360,
                      child: Container(
                        alignment: Alignment.center,
                        child: YoutubePlayer(
                          controller: YoutubePlayerController(
                            initialVideoId: trailerKey!,
                            flags: YoutubePlayerFlags(autoPlay: true),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (trailerKey == null)
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: cast.length,
                    itemBuilder: (context, index) {
                      final actor = cast[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(
                                  'https://image.tmdb.org/t/p/w185/${actor['profile_path']}'),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              actor['name'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              actor['character'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                decoration: TextDecoration.none,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
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
        'title': doc['title'],
      });
    });
    return moviesData; // Devuelve la lista de datos de películas
  }
}
