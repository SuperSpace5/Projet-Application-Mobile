// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

// Importer les bibliothèques nécessaires
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Classe principale représentant l'application
void main() {
  runApp(MyApp());
}

// Classe représentant l'application Flutter
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ping Test', // Titre de l'application
      theme: ThemeData(
        primarySwatch: Colors.blue, // Thème de couleur principale
      ),
      home: PingTestPage(), // Page d'accueil de l'application
    );
  }
}

// Classe représentant la page de test de ping
class PingTestPage extends StatefulWidget {
  @override
  _PingTestPageState createState() => _PingTestPageState();
}

// Classe d'état de la page de test de ping
class _PingTestPageState extends State<PingTestPage> {
  String _pingResult = ''; // Résultat du ping

  // Méthode pour effectuer un test de ping
  Future<void> _testPing() async {
    try {
      // Effectuer une requête HTTP GET vers l'URL spécifiée
      final response =
          await http.get(Uri.parse('http://192.168.137.3:8080/test/ping'));
      // Vérifier si la réponse est OK (code 200)
      if (response.statusCode == 200) {
        // Mettre à jour le résultat du ping en cas de succès
        setState(() {
          _pingResult = 'Ping réussi';
        });
      } else {
        // Mettre à jour le résultat du ping en cas d'échec avec le code de statut
        setState(() {
          _pingResult = 'Échec du ping : ${response.statusCode}';
        });
      }
    } catch (e) {
      // Mettre à jour le résultat du ping en cas d'erreur
      setState(() {
        _pingResult = 'Échec du ping : $e';
      });
    }
  }

  // Méthode pour construire l'interface utilisateur de la page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test de Ping'), // Titre de la barre d'applications
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _testPing, // Action lorsque le bouton est pressé
              child: const Text('Test Ping'), // Texte du bouton
            ),
            const SizedBox(height: 20), // Espacement
            Text(
              _pingResult, // Affichage du résultat du ping
              style: const TextStyle(fontSize: 18), // Style du texte
            ),
          ],
        ),
      ),
    );
  }
}
