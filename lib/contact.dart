// Ignorer les avertissements concernant l'utilisation des clés dans les constructeurs de widgets
// ignore_for_file: use_key_in_widget_constructors

// Importation de la bibliothèque Flutter
import 'package:flutter/material.dart';

// Fonction principale pour exécuter l'application Flutter
void main() {
  runApp(MyApp());
}

// Classe principale de l'application, héritant de StatelessWidget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Réservation Mobile-Home', // Titre de l'application
      theme: ThemeData(
        primarySwatch: Colors.blue, // Thème de l'application
      ),
      home: ContactPage(), // Page d'accueil de l'application
    );
  }
}

// Page de contact de l'application, héritant de StatelessWidget
class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/navigation/contact.png',
                width:
                    20), // Icône de contact à gauche du titre de l'application
            const SizedBox(width: 8), // Espacement entre l'icône et le titre
            const Text(
              'Contact', // Titre de la page de contact
              style: TextStyle(
                  fontWeight: FontWeight.bold), // Mise en gras du titre
            ),
          ],
        ),
        backgroundColor: const Color(0xFFd9d9d9), // Couleur de l'en-tête
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/logo.png', // Logo de l'application
              width: 300,
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'En cas de problèmes, veuillez nous contacter via :', // Message d'information
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold), // Style du texte
                textAlign: TextAlign.center, // Alignement du texte
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Adresse E-mail : mobilehomeparadis@gmail.com\n\nTéléphone : 06.85.85.85.85\n\nAdresse Camping : 123 Rue des Mobiles Homes, 11170 Gruissan', // Informations de contact
              style: TextStyle(
                  fontSize: 20, color: Colors.black), // Style du texte
              textAlign: TextAlign.center, // Alignement du texte
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/contact/tour.jpg', // Image de contact supplémentaire
              width: 375,
            ),
          ],
        ),
      ),
    );
  }
}
