// ignore_for_file: use_key_in_widget_constructors

// Ignorer certaines règles de lint
// Importer les bibliothèques nécessaires
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'accueil.dart'; // Importer le fichier accueil.dart

void main() {
  runApp(MyApp());
}

// Classe principale de l'application Flutter
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ping Test', // Titre de l'application
      theme: ThemeData(
        primarySwatch: Colors.blue, // Thème de l'application
      ),
      // Utilisation de FutureBuilder pour gérer l'état asynchrone
      home: FutureBuilder(
        future:
            _checkApiStatus(), // Utilisation de la fonction _checkApiStatus pour vérifier l'état de l'API
        builder: (BuildContext context, AsyncSnapshot<bool?> snapshot) {
          // Vérification de l'état de connexion
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Affichage de l'indicateur de chargement en attendant la réponse de l'API
          } else {
            final apiStatus = snapshot
                .data; // Récupération de l'état de l'API à partir du snapshot
            if (apiStatus == null || !apiStatus) {
              // Si l'API ne fonctionne pas correctement
              // Afficher une boîte de dialogue d'erreur et fermer l'application
              return ErrorPopup();
            } else {
              // Si l'API fonctionne correctement
              // Afficher une boîte de dialogue de succès et rediriger vers la page d'accueil
              return SuccessPopup();
            }
          }
        },
      ),
    );
  }

  // Fonction asynchrone pour vérifier l'état de l'API
  Future<bool?> _checkApiStatus() async {
    try {
      // Utilisation de Future.any pour envoyer une requête ping à l'API avec une limite de temps
      final response = await Future.any([
        http.get(Uri.parse(
            'http://192.168.137.3:8080/test/ping')), // Envoi d'une requête ping à l'adresse spécifiée
        Future.delayed(const Duration(seconds: 5))
            .then((_) => throw 'Timeout'), // Limite de temps de 5 secondes
      ]);
      return response.statusCode ==
          200; // Retourne vrai si le code de statut de la réponse est 200 (OK)
    } catch (e) {
      return false; // Retourne faux en cas d'erreur
    }
  }
}

// Widget pour afficher une boîte de dialogue de succès
class SuccessPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
          'API en marche'), // Titre de la boîte de dialogue de succès
      content:
          const Text('L\'API fonctionne correctement.'), // Message de succès
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).popUntil((route) => route
                .isFirst); // Fermer toutes les routes jusqu'à la première page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AccueilPage()), // Rediriger vers la page d'accueil
            );
          },
          child: const Text('OK'), // Bouton OK pour fermer la boîte de dialogue
        ),
      ],
    );
  }
}

// Widget pour afficher une boîte de dialogue d'erreur
class ErrorPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Erreur API'), // Titre de la boîte de dialogue d'erreur
      content: const Text('L\'API ne fonctionne pas.'), // Message d'erreur
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Ferme la boîte de dialogue
            exit(0); // Quitte l'application
          },
          child: const Text('OK'), // Bouton OK pour fermer la boîte de dialogue
        ),
      ],
    );
  }
}
