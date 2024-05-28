import 'package:flutter/material.dart';
import 'package:mobile_home_and_paradise/accueil.dart';
import 'package:mobile_home_and_paradise/config.dart';
import 'package:mobile_home_and_paradise/reservations.dart';
import 'contact2.dart';
import 'code.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  String? _nom;
  String? _prenom;
  String? _genre;
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadAccountInfo();
  }

  Future<void> _loadAccountInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nom = prefs.getString('nom');
      _prenom = prefs.getString('prenom');
      _genre = prefs.getString('genre');
      _token = prefs.getString('token');

      if (_genre == "M") {
        _genre = "Monsieur";
      } else if (_genre == "F") {
        _genre = "Madame";
      }
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AccueilPage()),
    );
  }

  Future<void> _sendToken() async {
    if (_token == null) {
      _showErrorDialog("Token non disponible");
      return;
    }

    String apiUrl = '$apiUrlo/account/mobile/refresh';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'Token': _token,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        _showSuccessDialog("Token envoyé avec succès: ${responseBody['info']}");
      } else {
        final responseBody = jsonDecode(response.body);
        _showErrorDialog("Échec de l'envoi du token : ${responseBody['info']}");
      }
    } catch (e) {
      _showErrorDialog("Erreur lors de l'envoi du token : $e");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Fermer la boîte de dialogue après un délai
        Future.delayed(const Duration(seconds: 99), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          backgroundColor: Colors.red, // Fond rouge pour les erreurs
          title: const Text(
            "Erreur", // Titre de la boîte de dialogue
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold), // Texte blanc en gras
          ),
          content: Text(
            message, // Contenu de la boîte de dialogue
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold), // Texte blanc en gras
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
              child: const Text(
                "OK", // Texte du bouton
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold), // Texte blanc en gras
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Succès"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              'Bonjour \n${_genre ?? ''} ${_nom ?? ''} ${_prenom ?? ''}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendToken,
              child: const Text('Envoyer Token'),
            ),
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
            label: 'Réservations',
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
              onTap: () async {
                bool logoutConfirmed = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Déconnexion'),
                      content: const Text('Voulez-vous vous déconnecter ?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: const Text('Oui'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text('Non'),
                        ),
                      ],
                    );
                  },
                );

                if (logoutConfirmed == true) {
                  await _logout();
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
