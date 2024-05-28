// connexion.dart

// Importations nécessaires pour utiliser Flutter
// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'creercompte.dart'; // Importe le fichier creercompte.dart ici
import 'mdpoublie.dart'; // Importe le fichier mdpoublie.dart ici
import 'profil.dart'; // Importe le fichier profil.dart ici
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart'; // Importe le fichier config.dart ici

// Fonction principale du programme Flutter
void main() {
  runApp(MyApp());
}

// Widget principal de l'application
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Réservation Mobile-Home', // Titre de l'application
      theme: ThemeData(
        primarySwatch: Colors.green, // Thème principal de l'application
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ConnexionPage(), // Page d'accueil de l'application
    );
  }
}

// Page de connexion de l'application
class ConnexionPage extends StatefulWidget {
  @override
  _ConnexionPageState createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> {
  // Contrôleurs pour les champs de saisie de l'email et du mot de passe
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword =
      false; // Indicateur pour afficher ou masquer le mot de passe

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/navigation/compte.png',
                width: 20), // Icône de compte à gauche du titre
            const SizedBox(width: 8), // Espacement entre l'icône et le titre
            const Text(
              'Connexion',
              style: TextStyle(fontWeight: FontWeight.bold),
            ), // Titre de la page
          ],
        ),
        backgroundColor: const Color(0xFFd9d9d9), // Couleur de l'en-tête
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
              Image.asset(
                'assets/images/logo.png',
                width: 300,
              ), // Logo de l'application
              const SizedBox(height: 20),
              const Text(
                'Connexion', // Titre de la section de connexion
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email :', // Champ de saisie de l'email
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText:
                      'Mot de passe :', // Champ de saisie du mot de passe
                  suffixIcon: IconButton(
                    icon: Icon(_showPassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed:
                        _togglePasswordVisibility, // Bouton pour afficher/masquer le mot de passe
                  ),
                ),
                obscureText: !_showPassword,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _submitForm(
                    context), // Action à effectuer lors de la soumission du formulaire de connexion
                child: const Text('Se connecter',
                    style: TextStyle(
                        fontWeight: FontWeight.bold)), // Bouton de connexion
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MotDePasseOubliePage()), // Rediriger vers la page de mot de passe oublié
                      );
                    },
                    child: const Text('Mot de passe oublié',
                        style: TextStyle(
                            fontWeight: FontWeight
                                .bold)), // Bouton pour mot de passe oublié
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CreerComptePage()), // Rediriger vers la page de création de compte
                      );
                    },
                    child: const Text('Créer un compte',
                        style: TextStyle(
                            fontWeight: FontWeight
                                .bold)), // Bouton pour créer un compte
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fonction pour basculer l'affichage du mot de passe
  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  // Fonction pour soumettre le formulaire de connexion
  void _submitForm(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Vérification des champs de saisie
    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog(context, "Veuillez remplir tous les champs");
      return;
    } else if (!_isEmailValid(email)) {
      _showErrorDialog(context, "Veuillez entrer une adresse email valide");
      return;
    }

    // Hachage du mot de passe
    String hashedPassword = _hashPassword(password);

    // Utiliser la variable apiUrl de config.dart
    String apiUrl = '$apiUrlo/account/mobile/login';

    // Envoi du formulaire de connexion
    String resultCode = await _sendLoginForm(email, hashedPassword, apiUrl);

    // Traitement des résultats de la connexion
    if (resultCode == '1000') {
      // Rediriger vers la page de profil si la réponse est valide
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

  // Fonction pour hacher le mot de passe
  String _hashPassword(String password) {
    // Encode le mot de passe en une liste d'octets utilisant l'encodage UTF-8
    List<int> bytes = utf8.encode(password);
    // Calcule le hash SHA-256 des octets encodés
    Digest digest = sha256.convert(bytes);
    // Retourne le hash sous forme de chaîne de caractères
    return digest.toString();
  }

  // Fonction pour envoyer le formulaire de connexion
  Future<String> _sendLoginForm(
      String email, String hashedPassword, String apiUrl) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'email': email,
          'password': hashedPassword,
        },
      );
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        // Stocke les informations du compte dans les préférences partagées
        await _saveAccountInfo(responseBody);
        print(responseBody);
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
    await prefs.setString('nom', accountInfo['nom']);
    await prefs.setString('prenom', accountInfo['prenom']);
    await prefs.setString('genre', accountInfo['genre']);
    await prefs.setString('token', accountInfo['Token']);

    String accountStatus = accountInfo['compteActif'];
    if (accountStatus == '0') {
      // Afficher un message d'erreur si le compte est inactif
      _showErrorDialog(context, "Compte inactif");
    }
  }

  // Fonction pour vérifier si l'email est valide
  bool _isEmailValid(String email) {
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  // Fonction pour afficher une boîte de dialogue d'erreur
  void _showErrorDialog(BuildContext context, String message) {
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
}
