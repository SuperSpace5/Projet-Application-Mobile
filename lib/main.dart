import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'accueil.dart';
import 'profil.dart';
import 'config.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<dynamic> _delayedApiCheck() async {
    try {
      await Future.delayed(const Duration(seconds: 3));
      return _checkApiStatus();
    } catch (error) {
      return error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ping Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _delayedApiCheck(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen(error: null);
          } else {
            if (snapshot.hasError) {
              return LoadingScreen(error: snapshot.error.toString());
            } else {
              final apiStatus = snapshot.data as bool?;
              if (apiStatus == null || !apiStatus) {
                return const ErrorPopup();
              } else {
                return FutureBuilder(
                  future: _checkAccountData(),
                  builder:
                      (BuildContext context, AsyncSnapshot<bool?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LoadingScreen(error: null);
                    } else {
                      final hasAccountData = snapshot.data;
                      if (hasAccountData == null || !hasAccountData) {
                        return WelcomePopup();
                      } else {
                        _showWelcomeBackPopup(
                            context); // Show welcome back popup if account data is available
                        return const LoadingScreen(
                            error:
                                null); // Show loading screen until welcome back popup is displayed
                      }
                    }
                  },
                );
              }
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
      throw 'Erreur API'; // Lance une erreur si la vérification échoue
    }
  }

  Future<bool?> _checkAccountData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? genre = prefs.getString('genre');
    String? nom = prefs.getString('nom');
    String? prenom = prefs.getString('prenom');
    return genre != null && nom != null && prenom != null;
  }
}

Future<void> _showWelcomePopup(BuildContext context) async {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Bienvenue'),
        content: const Text('Bienvenue sur l\'application.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AccueilPage()),
              );
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

Future<void> _showWelcomeBackPopup(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? genre = prefs.getString('genre');
  if (genre == "M") {
    genre = "Monsieur";
  } else if (genre == "F") {
    genre = "Madame";
  }
  String? nom = prefs.getString('nom');
  String? prenom = prefs.getString('prenom');
  String welcomeBackMessage = 'Bonjour $genre $nom $prenom.';

  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Bonjour'),
        content: Text(welcomeBackMessage),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfilPage()),
              );
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

class WelcomePopup extends StatefulWidget {
  @override
  _WelcomePopupState createState() => _WelcomePopupState();
}

class _WelcomePopupState extends State<WelcomePopup> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWelcomePopup(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const LoadingScreen(error: null);
  }
}

class LoadingScreen extends StatelessWidget {
  final String? error;

  const LoadingScreen({Key? key, this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Utilise la couleur transparente pour le fond
      body: Stack(
        children: <Widget>[
          // Fond d'écran avec l'image "soleil.jpg"
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fond_pages/soleil.jpg'),
                fit: BoxFit.cover, // Ajuste la taille de l'image selon l'écran
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Assure-toi d'ajouter le logo de ton application ici
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20), // Coins arrondis
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Image.asset(
                    'assets/images/logo.png', // Remplace par le chemin correct de ton logo
                    height: 150,
                  ),
                ),
                const SizedBox(height: 20),
                if (error != null)
                  ErrorPopup(
                      error:
                          error), // Utilise ErrorPopup pour afficher la pop-up d'erreur
                if (error == null)
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
              ],
            ),
          ),
        ],
      ),
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
  final String? error;

  const ErrorPopup({Key? key, this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.red, // Fond rouge
      title: const Text(
        'Erreur API',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ), // Police blanche et en gras
      ),
      content: const Text(
        'L\'API ne fonctionne pas.', // Utiliser le texte spécifié
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ), // Police blanche et en gras
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            exit(0);
          },
          child: const Text(
            'OK',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ), // Bouton OK blanc et en gras
          ),
        ),
      ],
    );
  }
}
