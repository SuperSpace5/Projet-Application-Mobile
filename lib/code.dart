// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'dart:math'; // Importation de la bibliothèque pour utiliser Random
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Réservation Mobile-Home',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CodePage(),
    );
  }
}

class CodePage extends StatefulWidget {
  @override
  _CodePageState createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  String generatedCode = ''; // Variable pour stocker le code généré

  // Fonction pour générer un code à 4 chiffres
  void generateCode() {
    Random random = Random();
    setState(() {
      generatedCode = ''; // Réinitialise le code généré
      for (int i = 0; i < 4; i++) {
        generatedCode += random
            .nextInt(10)
            .toString(); // Ajoute un chiffre aléatoire au code
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/navigation/code.png', width: 20),
            const SizedBox(width: 8),
            const Text(
              'Accès Mobile Home',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFd9d9d9),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Image.asset('assets/images/logo.png', width: 300),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Retrouver ci-dessous le code pour ouvrir la serrure de la porte de votre mobile-home \n',
                    style: TextStyle(fontSize: 24, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    '\nCode de la Serrure',
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            ElevatedButton(
              // Bouton "Demander Code d'accès"
              onPressed: () {
                // Ajouter code demander le code d'accès (attente api)
              },
              child: const Text('Demander Code d\'accès'),
            ),
            const SizedBox(height: 10), // Espacement vertical
            ElevatedButton(
              // Bouton "Générer Code d'accès"
              onPressed: () {
                generateCode(); // Appel de la fonction pour générer le code
                showDialog(
                  // Afficher une pop-up avec le code généré
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Code d\'accès généré'),
                      content: Text('Votre code d\'accès est : $generatedCode'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Fermer la pop-up
                          },
                          child: const Text('Fermer'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Générer Code d\'accès'),
            ),
          ],
        ),
      ),
    );
  }
}
