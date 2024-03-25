import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiCast {
  Future<List<Map<String, dynamic>>?> getCast(int idMovie) async {
    final apiKey = 'f6dfa5b6b89387c9e6841b7f6365396c&language=es-MX&page=1';
    final castApiURL = Uri.parse(
        'https://api.themoviedb.org/3/movie/$idMovie/credits?api_key=$apiKey');
    final response = await http.get(castApiURL);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<Map<String, dynamic>> cast =
          List<Map<String, dynamic>>.from(data['cast']);
      return cast;
    }
    return null;
  }
}
