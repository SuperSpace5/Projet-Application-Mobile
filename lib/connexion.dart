import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'creercompte.dart';
import 'mdpoublie.dart';
import 'profil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Réservation Mobile-Home',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ConnexionPage(),
    );
  }
}

class ConnexionPage extends StatefulWidget {
  @override
  _ConnexionPageState createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/navigation/compte.png', width: 20),
            const SizedBox(width: 8),
            const Text(
              'Connexion',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFd9d9d9),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          width: 500.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', width: 300),
              const SizedBox(height: 20),
              const Text(
                'Connexion',
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email :'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Mot de passe :',
                  suffixIcon: IconButton(
                    icon: Icon(_showPassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () =>
                        setState(() => _showPassword = !_showPassword),
                  ),
                ),
                obscureText: !_showPassword,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _submitForm(context),
                child: const Text('Se connecter',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        _navigateToPage(context, MotDePasseOubliePage()),
                    child: const Text('Mot de passe oublié',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        _navigateToPage(context, CreerComptePage()),
                    child: const Text('Créer un compte',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog(context, "Veuillez remplir tous les champs");
      return;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showErrorDialog(context, "Veuillez entrer une adresse email valide");
      return;
    }

    String hashedPassword = sha256.convert(utf8.encode(password)).toString();
    String apiUrl = '$apiUrlo/account/mobile/login';

    String resultCode = await _sendLoginForm(email, hashedPassword, apiUrl);

    if (resultCode == '1000') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilPage()),
      );
    } else if (resultCode == '0000') {
      _showErrorDialog(context, "Erreur interne inconnue");
    } else if (resultCode == '0001') {
      _showErrorDialog(context, "Le chiffrement du mot de passe est absent");
    } else if (resultCode == '0002') {
      _showErrorDialog(context, "Format incorrect");
    } else if (resultCode == '0100') {
      _showErrorDialog(context, "Identification invalide");
    } else if (resultCode == '0101') {
      _showErrorDialog(context, "Compte inactif");
    } else if (resultCode == '0121') {
      _showErrorDialog(context, "Code expiré");
    } else if (resultCode == '0117') {
      _showErrorDialog(context, "Compte inexistant");
    }
  }

  Future<String> _sendLoginForm(
      String email, String hashedPassword, String apiUrl) async {
    try {
      final response = await http.post(Uri.parse(apiUrl),
          body: {'email': email, 'password': hashedPassword});
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        await _saveAccountInfo(responseBody);
        return responseBody["info"];
      } else {
        throw Exception(
            "Échec du chargement des données. Code d'état : ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur lors de l'envoi du formulaire de connexion : $e");
      return '';
    }
  }

  Future<void> _saveAccountInfo(Map<String, dynamic> accountInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nom', accountInfo['nom'] ?? '');
    await prefs.setString('prenom', accountInfo['prenom'] ?? '');
    await prefs.setString('genre', accountInfo['genre'] ?? '');
    await prefs.setString('token', accountInfo['Token'] ?? '');
    await prefs.setString(
        'compteActif', accountInfo['compteActif']?.toString() ?? '0');

    if (accountInfo['compteActif'] == 0) {
      _showErrorDialog(context, "Compte inactif");
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          title: const Text("Erreur",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: Text(message,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}

void _showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.red,
        title: const Text("Erreur",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(message,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      );
    },
  );
}
