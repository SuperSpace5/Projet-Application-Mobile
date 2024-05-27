// ignore_for_file: use_key_in_widget_constructors

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'accueil.dart';
import 'connexion.dart';
import 'config.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ping Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: _checkApiStatus(),
        builder: (BuildContext context, AsyncSnapshot<bool?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            final apiStatus = snapshot.data;
            if (apiStatus == null || !apiStatus) {
              return ErrorPopup();
            } else {
              return FutureBuilder(
                future: _checkAccountData(),
                builder: (BuildContext context, AsyncSnapshot<bool?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    final hasAccountData = snapshot.data;
                    if (hasAccountData == null || !hasAccountData) {
                      return SuccessPopup();
                    } else {
                      return FutureBuilder(
                        future: _showAccountDataPopup(context),
                        builder: (BuildContext context,
                            AsyncSnapshot<void> snapshot) {
                          return Container(); // Placeholder widget, actual UI is built in _showAccountDataPopup
                        },
                      );
                    }
                  }
                },
              );
            }
          }
        },
      ),
    );
  }

  Future<bool?> _checkApiStatus() async {
    try {
      final response = await Future.any([
        http.get(Uri.parse('$apiUrlo/mobile/ping')),
        Future.delayed(const Duration(seconds: 5)).then((_) => throw 'Timeout'),
      ]);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool?> _checkAccountData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? genre = prefs.getString('genre');
    String? nom = prefs.getString('nom');
    String? prenom = prefs.getString('prenom');
    return genre != null && nom != null && prenom != null;
  }

  Future<void> _showAccountDataPopup(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? genre = prefs.getString('genre');

    if (genre == "M") {
      genre = "Monsieur";
    } else if (genre == "F") {
      genre = "Madame";
    }

    String? nom = prefs.getString('nom');
    String? prenom = prefs.getString('prenom');
    String welcomeMessage =
        'Bonjour $genre $nom $prenom. Veuillez-vous reconnecter.';

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Re-Bienvenue'),
          content: Text(welcomeMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ConnexionPage()),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class SuccessPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('API en marche'),
      content: const Text('L\'API fonctionne correctement.'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AccueilPage()),
            );
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class ErrorPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Erreur API'),
      content: const Text('L\'API ne fonctionne pas.'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            exit(0);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
