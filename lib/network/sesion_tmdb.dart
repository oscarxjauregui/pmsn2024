
import 'dart:convert';

import 'package:pmsn2024/model/session_model.dart';
import 'package:http/http.dart' as http;

class SessionID{
  final String apiKey = 'f6dfa5b6b89387c9e6841b7f6365396c';
  final String username = 'oscarxjauregui';
  final String password = 'Oscarjaro8';
  SessionManager sessionManager = SessionManager();

  String? sessionId;

  Future<void> getSession() async {
    final responseToken = await http.get(Uri.parse(
      'https://api.themoviedb.org/3/authentication/token/new?api_key=$apiKey'));
    final tokenJson = json.decode(responseToken.body);
    final String requestToken = tokenJson['request_token'];

    final responseLogin = await http.post(
      Uri.parse('https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=$apiKey'),
      body: {
        'username': username,
        'password': password,
        'request_token': requestToken,
      },
    );
    final loginJson = json.decode(responseLogin.body);
    final bool? loginSuccess = loginJson['succes'];

    if (loginSuccess == true) {
      final responseSession = await http.post(
        Uri.parse('https://api.themoviedb.org/3/authentication/session/new?api_key=$apiKey'),
        body: {
          'request_token': requestToken,
        },
      );
      final sessionJson = json.decode(responseSession.body);
      sessionId = sessionJson['session_id'];
      sessionManager.setSessionId(sessionId!);
    }
  }
}