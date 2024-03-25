// import 'package:dio/dio.dart';
// import 'package:pmsn2024/model/popular_model.dart';

// class ApiPopular {
//   final dio = Dio();
//   final Url =
//       "https://api.themoviedb.org/3/movie/popular?api_key=f6dfa5b6b89387c9e6841b7f6365396c&language=es-MX&page=1";

//   Future<List<PopularModel>?> getPopularMovie() async {
//     //Todo lo que involucre cosas asincronas se debe de usar future.
//     Response response =
//         await dio.get(Url); //Si fuera con una uri se tendria que parsear
//     if (response.statusCode == 200) {
//       final listMovies = response.data['results']
//           as List; //Con este parseo se obtiene los elementos de la respuesta ya que no esta directo en el data
//       return listMovies.map((movie) => PopularModel.fromMap(movie)).toList();
//     }
//     return null;
//   }
// }

import 'package:dio/dio.dart';
import 'package:pmsn2024/model/popular_model.dart';

class ApiPopular{
  final dio = Dio();
  final baseUrl = "https://api.themoviedb.org/3";
  final apiKey = "f6dfa5b6b89387c9e6841b7f6365396c";
  final accountID = "20522427";
  //final urlPopular = "https://api.themoviedb.org/3/movie/popular?api_key=45d69ee8ce7b6736b37ab4bc080fb3e2&language=es-MX&page=1";

  //Para traer las peliculas populares
  Future<List<PopularModel>?> getPopularMovie() async{ //Todo lo que involucre cosas asincronas se debe de usar future.
    final url = "$baseUrl/movie/popular?api_key=$apiKey&language=es-MX&page=1";
    Response response = await dio.get(url); //Si fuera con una uri se tendria que parsear
    
    if(response.statusCode == 200){
      //print(response.data['results'].runtimeType); //Comprueba si hay cosas en el response y el runtimeType dice de que tipo es lo recibido
      final listMovies = response.data['results'] as List; //Con este parseo se obtiene los elementos de la respuesta ya que no esta directo en el data
      return listMovies.map((movie) => PopularModel.fromMap(movie)).toList();// Quitamos el jsonDecode porque ya regresaba una lista tal cual y no era necesario
    }
    return null;
  }


  //Para agregar una pelicula a favoritos
  Future<void> addToFavorites(int movieId, String sessionId) async {
    final url = "$baseUrl/account/$accountID/favorite?api_key=$apiKey&session_id=$sessionId";
    try {
      final response = await dio.post(
        url,
        data: {
          "media_type": "movie",
          "media_id": movieId.toString(),
          "favorite": true, // Agregar a favoritos
        },
      );

      if (response.statusCode == 201) {
        print("Película agregada a favoritos exitosamente");
      } else {
        print("Error al agregar película a favoritos: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  //Para remover una pelicula de favoritos
  Future<void> removeFromFavorites(int movieId, String sessionId) async {
    final url = "$baseUrl/account/$accountID/favorite?api_key=$apiKey&session_id=$sessionId";
    
    try {
      final response = await dio.post(
        url,
        data: {
          "media_type": "movie",
          "media_id": movieId.toString(),
          "favorite": false, // Eliminar de favoritos
        },
      );

      if (response.statusCode == 200) {
        print("Película eliminada de favoritos exitosamente");
      } else {
        print("Error al eliminar película de favoritos: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  //Para mostrar las peliculas de favoritos
  Future<List<PopularModel>?> getFavoriteMovies(String sessionId) async {
    final url = "$baseUrl/account/$accountID/favorite/movies?api_key=$apiKey&session_id=$sessionId";

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['results'];
        return data.map((json) => PopularModel.fromMap(json)).toList();
      } else {
        print("Error al obtener las películas favoritas: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error al obtener las películas favoritas: $e");
      return null;
    }
  }
}