import 'package:flutter/material.dart';
import 'package:mobile_home_and_paradise/accueil.dart';
import 'package:mobile_home_and_paradise/reservations.dart';
import 'contact2.dart';
import 'code.dart';
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

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  String? _nom;
  String? _prenom;
  String? _genre;

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
