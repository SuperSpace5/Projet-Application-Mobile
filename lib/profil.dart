import 'package:flutter/material.dart';
import 'package:mobile_home_and_paradise/accueil.dart';
import 'package:mobile_home_and_paradise/config.dart';
import 'package:mobile_home_and_paradise/reservations.dart';
import 'contact2.dart';
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
  String? _nom, _prenom, _genre, _token;

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
      _genre = prefs.getString('genre') == "M" ? "Monsieur" : "Madame";
      _token = prefs.getString('token');
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
        body: jsonEncode({'Token': _token}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        print("Info: ${responseBody['info']}");
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
    _showDialog("Erreur", message, Colors.red);
  }

  void _showSuccessDialog(String message) {
    _showDialog("Succès", message, Colors.green);
  }

  void _showDialog(String title, String message, Color backgroundColor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 99), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            message,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "OK",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/fond_pages/couleur-ciel.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Bonjour \n${_genre ?? ''} ${_nom ?? ''} ${_prenom ?? ''}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFd9edf7),
        items: [
          _bottomNavItem(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => ReservationPage())),
            iconPath: 'assets/images/navigation/reservation.png',
            label: 'Réservations',
          ),
          _bottomNavItem(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => ContactPage2())),
            iconPath: 'assets/images/navigation/contact.png',
            label: 'Contact',
          ),
          _bottomNavItem(
            onTap: _logoutPrompt,
            iconPath: 'assets/images/navigation/logout.png',
            label: 'Logout',
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _bottomNavItem(
      {required Function() onTap,
      required String iconPath,
      required String label}) {
    return BottomNavigationBarItem(
      icon: GestureDetector(
        onTap: onTap,
        child: Image.asset(iconPath, width: 30),
      ),
      label: label,
    );
  }

  void _logoutPrompt() async {
    bool logoutConfirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Voulez-vous vous déconnecter ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Oui'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Non'),
            ),
          ],
        );
      },
    );

    if (logoutConfirmed == true) {
      await _logout();
    }
  }
}
