import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> login(String email, String password) async {
  final response = await http.post(
    Uri.parse('http://192.168.95.84:8080/account/mobile/login_form_mobile'),
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: <String, String>{
      'email': email,
      'password': password,
    },
  );

  if (response.statusCode == 200) {
    // Si le serveur retourne une réponse OK, parsez le JSON.
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    // Vérifiez le code d'erreur.
    if (jsonResponse['info'] == '0102') {
      print('Authentification réussie.');

      // Stockez le cookie de session dans les préférences partagées.
      String? sessionCookie = response.headers['set-cookie'];
      if (sessionCookie != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('sessionCookie', sessionCookie);
      }
    } else if (jsonResponse['info'] == '0103') {
      print('Erreur d\'authentification.');
      throw Exception('Failed to login.');
    }
  } else {
    // Si cette réponse n'est pas OK, lancez une exception.
    throw Exception('Failed to login.');
  }
}
