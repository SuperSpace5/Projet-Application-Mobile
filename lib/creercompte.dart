// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously

// Importations de packages Flutter
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart'; // Package pour le hachage des mots de passe
import 'connexion.dart';
import 'config.dart';

// Fonction principale pour exécuter l'application Flutter
void main() {
  runApp(MyApp());
}

// Classe principale de l'application, héritant de StatelessWidget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Créer un compte', // Titre de l'application
      theme: ThemeData(
        primarySwatch: Colors.green, // Thème de l'application
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CreerComptePage(), // Page d'accueil de l'application
    );
  }
}

// Page de création de compte de l'application, héritant de StatefulWidget
class CreerComptePage extends StatefulWidget {
  @override
  _CreerComptePageState createState() => _CreerComptePageState();
}

// État de la page de création de compte de l'application
class _CreerComptePageState extends State<CreerComptePage> {
  // Contrôleurs pour les champs de texte
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variable pour afficher ou masquer le mot de passe
  bool _showPassword = false;
  // Variable pour stocker le genre (Homme ou Femme)
  String genre = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Créer un compte', // Titre de la page
          style:
              TextStyle(fontWeight: FontWeight.bold), // Mise en gras du titre
        ),
        backgroundColor: const Color(0xFFd9d9d9), // Couleur de l'en-tête
      ),
      body: SingleChildScrollView(
        child: Center(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png', // Chemin de l'image du logo
                      width: 300,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Sélection du genre (Masculin ou Féminin)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          genre = 'M';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(
                              color: genre == 'M' ? Colors.blue : Colors.black),
                        ),
                      ),
                      child: Text(
                        'M',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: genre == 'M' ? Colors.blue : Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          genre = 'F';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(
                              color: genre == 'F' ? Colors.blue : Colors.black),
                        ),
                      ),
                      child: Text(
                        'F',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: genre == 'F' ? Colors.blue : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Champ de texte pour le nom
                TextField(
                  controller: _nomController,
                  decoration: const InputDecoration(
                    labelText: 'Nom :',
                  ),
                ),
                const SizedBox(height: 10),
                // Champ de texte pour le prénom
                TextField(
                  controller: _prenomController,
                  decoration: const InputDecoration(
                    labelText: 'Prénom :',
                  ),
                ),
                const SizedBox(height: 10),
                // Champ de texte pour l'adresse email
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Adresse Email :',
                  ),
                  keyboardType: TextInputType.emailAddress, // Type de clavier
                ),
                const SizedBox(height: 10),
                // Champ de texte pour le numéro de téléphone
                TextField(
                  controller: _numeroController,
                  decoration: const InputDecoration(
                    labelText: 'Numéro de Téléphone :',
                  ),
                  keyboardType: TextInputType.phone, // Type de clavier
                ),
                const SizedBox(height: 10),
                // Champ de texte pour le mot de passe
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe :',
                    suffixIcon: IconButton(
                      icon: Icon(_showPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                  obscureText: !_showPassword,
                ),
                const SizedBox(height: 20),
                // Bouton pour soumettre le formulaire
                ElevatedButton(
                  onPressed: () => _submitForm(context),
                  child: const Text(
                    'Confirmer', // Texte du bouton
                    style: TextStyle(
                        fontWeight: FontWeight.bold), // Style du texte
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Méthode pour basculer l'affichage du mot de passe
  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  // Méthode pour soumettre le formulaire
  void _submitForm(BuildContext context) async {
    // Récupération des valeurs des champs de texte
    String nom = _nomController.text.trim();
    String prenom = _prenomController.text.trim();
    String email = _emailController.text.trim();
    String numero = _numeroController.text.trim();
    String password = _passwordController.text.trim();

    // Hachage du mot de passe
    String hashedPassword = _hashPassword(password);

    // URL de l'API pour la création de compte
    String apiUrl = '$apiUrlo/account/creationCompte_form';

    // Envoi du formulaire et réception du résultat
    String resultCode = await _sendLoginForm(
        genre, nom, prenom, email, numero, hashedPassword, apiUrl);

    // Vérification du résultat et affichage des messages d'erreur
    if (genre.isEmpty ||
        nom.isEmpty ||
        prenom.isEmpty ||
        email.isEmpty ||
        numero.isEmpty ||
        hashedPassword.isEmpty) {
      _showErrorDialog(context, "Veuillez remplir tous les champs");
    }

    // Affichage des messages d'erreur en fonction du code de résultat
    // (Les codes de résultat sont propres à votre application)
    if (resultCode == '0118') {
      _showSuccessDialog(context,
          "Le compte a été créé avec succès, veuillez cliquer sur le lien dans l'email que vous venez de recevoir");
    } else if (resultCode == '0000') {
      _showErrorDialog(context, "Erreur interne inconnue");
    } else if (resultCode == '0001') {
      _showErrorDialog(context, "Le chiffrement du mot de passe est absent");
    } else if (resultCode == '0002') {
      _showErrorDialog(context, "Format incorrect");
    } else if (resultCode == '0111') {
      _showErrorDialog(context, "Format de l'email incorrect");
    } else if (resultCode == '0112') {
      _showErrorDialog(context,
          "Format du nom invalide (vérifiez la majuscule au début et uniquement des minuscules ensuite)");
    } else if (resultCode == '0113') {
      _showErrorDialog(context,
          "Format du prénom est incorrect (vérifiez la majuscule au début et uniquement des minuscules ensuite)");
    } else if (resultCode == '0114') {
      _showErrorDialog(context,
          "Format du genre est incorrect (vérifiez le format du genre M ou F)");
    } else if (resultCode == '0115') {
      _showErrorDialog(context,
          "Format du numéro est incorrect (vérifiez le format du numéro)");
    } else if (resultCode == '0116') {
      _showErrorDialog(context, "Compte déjà existant");
    } else if (resultCode == '0119') {
      _showErrorDialog(context, "Compte déjà actif");
    } else if (resultCode == '0120') {
      _showErrorDialog(context, "Compte bloqué");
    }
  }

  // Méthode pour hacher le mot de passe
  String _hashPassword(String password) {
    List<int> bytes = utf8.encode(password);
    Digest digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Méthode pour envoyer le formulaire de création de compte à l'API
  Future<String> _sendLoginForm(String genre, String nom, String prenom,
      String email, String numero, String hashedPassword, String apiUrl) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'genre': genre,
          'nom': nom,
          'prenom': prenom,
          'email': email,
          'numero': numero,
          'password': hashedPassword,
        },
      );

      // Vérification du code de statut de la réponse
      if (response.statusCode == 200) {
        // Décodage de la réponse JSON
        Map<String, dynamic> data = json.decode(response.body);
        return data["info"]; // Renvoi des informations
      } else {
        // En cas d'erreur, lancer une exception avec le code de statut
        throw Exception(
            'Échec du chargement des données. Code d\'état : ${response.statusCode}');
      }
    } catch (e) {
      // Gestion des erreurs
      print(e);
      print('Erreur lors de l\'envoi du formulaire de connexion : $e');
      return ''; // Renvoi d'une chaîne vide en cas d'erreur
    }
  }

  // Méthode pour afficher une boîte de dialogue d'erreur
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Fermer la boîte de dialogue après un délai
        Future.delayed(const Duration(seconds: 99), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          title: const Text("Erreur"), // Titre de la boîte de dialogue
          content: Text(message), // Contenu de la boîte de dialogue
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
              child: const Text(
                  "OK"), // Texte du bouton pour fermer la boîte de dialogue
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Fermer la boîte de dialogue après un délai
        Future.delayed(const Duration(seconds: 99), () {
          Navigator.of(context).pop(true);
          // Rediriger vers la page de connexion (connexion.dart)
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => ConnexionPage()));
        });
        return AlertDialog(
          title: const Text("Succès"), // Titre de la boîte de dialogue
          content: Text(message), // Contenu de la boîte de dialogue
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
                // Rediriger vers la page de connexion (connexion.dart)
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => ConnexionPage()));
              },
              child: const Text(
                  "OK"), // Texte du bouton pour fermer la boîte de dialogue
            ),
          ],
        );
      },
    );
  }
}
