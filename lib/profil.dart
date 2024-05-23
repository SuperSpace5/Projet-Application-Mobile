// ignore_for_file: use_key_in_widget_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mobile_home_and_paradise/accueil.dart';
import 'package:mobile_home_and_paradise/reservations.dart';
import 'contact2.dart';
import 'code.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

// Fonction pour vérifier la présence du cookie de session
Future<bool> isSessionCookiePresent() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.containsKey('session_cookie');
}

// Fonction pour supprimer le cookie de session
Future<void> removeSessionCookie() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('session_cookie');
}

class ProfileInfo {
  final String nom;
  final String prenom;
  final String email;
  final String admin;

  ProfileInfo(
      {required this.nom,
      required this.prenom,
      required this.email,
      required this.admin});

  factory ProfileInfo.fromJson(Map<String, dynamic> json) {
    return ProfileInfo(
      nom: json['Nom'],
      prenom: json['Prenom'],
      email: json['Email'],
      admin: json["Admin"],
    );
  }
}

class ProfilPage extends StatelessWidget {
  Future<ProfileInfo> fetchProfileInfo() async {
    final bool isSessionCookie = await isSessionCookiePresent();

    if (!isSessionCookie) {
      throw Exception('Session cookie not present');
    }

    final response = await http
        .get(Uri.parse('http://192.168.135.84:8080/account/mobile/info'));

    if (response.statusCode == 200) {
      return ProfileInfo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load profile info');
    }
  }

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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            FutureBuilder<ProfileInfo>(
              future: fetchProfileInfo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Les données sont chargées, affichez-les
                  return Column(
                    children: [
                      Text('Nom : ${snapshot.data!.nom}'),
                      Text('Prénom : ${snapshot.data!.prenom}'),
                      Text('Email : ${snapshot.data!.email}'),
                      Text('Admin : ${snapshot.data!.admin}')
                    ],
                  );
                }
              },
            ),
            // Autres widgets
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CodePage()),
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
              onTap: () async {
                // Afficher la boîte de dialogue de confirmation pour la déconnexion
                bool logoutConfirmed = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Déconnexion'),
                      content: const Text('Voulez-vous vous déconnecter ?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(true); // Confirmer la déconnexion
                          },
                          child: const Text('Oui'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(false); // Annuler la déconnexion
                          },
                          child: const Text('Non'),
                        ),
                      ],
                    );
                  },
                );

                // Si la déconnexion est confirmée, supprimer le cookie de session et rediriger vers la page d'accueil
                if (logoutConfirmed == true) {
                  await removeSessionCookie();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AccueilPage()),
                  );
                }
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
