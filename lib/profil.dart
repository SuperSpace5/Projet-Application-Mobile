// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:mobile_home_and_paradise/accueil.dart';
import 'package:mobile_home_and_paradise/reservations.dart';
import 'contact2.dart';
import 'code.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Page de Profil',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfilPage(),
    );
  }
}

class ProfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/navigation/compte.png', width: 20),
            const SizedBox(width: 8),
            const Text(
              'Profil',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFd9d9d9),
      ),
      body: const SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            // Contenu de la page de profil
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFd9edf7),
        items: [
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReservationPage()),
                );
              },
              child: Image.asset('assets/images/navigation/reservation.png',
                  width: 30),
            ),
            label: 'Réserver',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactPage2()),
                );
              },
              child: Image.asset('assets/images/navigation/contact.png',
                  width: 30),
            ),
            label: 'Contact',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                // Affichage d'une boîte de dialogue avec les options Code et NFC
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Choisir une option"),
                      actions: <Widget>[
                        // Bouton "Code" pour aller vers la page Code
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CodePage()),
                            );
                          },
                          child: const Text('Code'),
                        ),
                      ],
                    );
                  },
                );
              },
              child:
                  Image.asset('assets/images/navigation/code.png', width: 30),
            ),
            label: 'Accès MH',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                // Action lorsqu'on appuie sur l'icône de paramètres
                // Naviguer vers la page de paramètres de compte
                // Implémentez cette navigation selon votre structure
              },
              child: Image.asset('assets/images/navigation/parametres.png',
                  width: 30),
            ),
            label: 'Paramètres',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AccueilPage()),
                );
              },
              child:
                  Image.asset('assets/images/navigation/logout.png', width: 30),
            ),
            label: 'Logout',
          ),
        ],
      ),
    );
  }
}
