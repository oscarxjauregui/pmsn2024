import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiTrailer {
  Future<String?> getTrailerVideoKey(int idMovie) async {
    final apiKey = '5019e68de7bc112f4e4337a500b96c56&language=es-MX&page=1';
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
