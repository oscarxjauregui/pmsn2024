import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiTrailer {
  Future<String?> getTrailerVideoKey(int idMovie) async {
    final apiKey = 'f6dfa5b6b89387c9e6841b7f6365396c&language=es-MX&page=1';
    final trailerApiURL = Uri.parse(
        'https://api.themoviedb.org/3/movie/$idMovie/videos?api_key=$apiKey');
    final response = await http.get(trailerApiURL);
    if (response.statusCode == 200) {
      final List<dynamic> videos = jsonDecode(response.body)['results'];
      for (final video in videos) {
        if (video['type'] == 'Trailer') {
          return video['key'];
        }
      }
    }
    return null;
  }
}
