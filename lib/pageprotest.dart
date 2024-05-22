// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_final_fields

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePageTest extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePageTest> {
  String _profileData = 'Loading...';

  @override
  void initState() {
    super.initState();
    makeAuthenticatedRequest();
  }

  Future<void> makeAuthenticatedRequest() async {
    // Récupérez le cookie de session des préférences partagées.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionCookie = prefs.getString('sessionCookie');

    if (sessionCookie != null) {
      final response = await http.get(
        Uri.parse('http://192.168.3.84:8080/account/mobile/info'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
          'Cookie': sessionCookie,
        },
      );

      if (response.statusCode == 200) {
        // Si le serveur retourne une réponse OK, parsez le JSON.
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
      } else {
        // Si cette réponse n'est pas OK, lancez une exception.
        throw Exception('Failed to make authenticated request.');
      }
    } else {
      // Gérez le cas où la clé 'sessionCookie' est absente ou sa valeur est null.
      print('La clé de session est absente ou null.');
      // Vous pouvez ajouter ici un code pour gérer ce cas en conséquence.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(_profileData),
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(home: ProfilePageTest()),
  );
}
