// ignore_for_file: use_key_in_widget_constructors

// Ignorer certaines règles de lint
// Importer les bibliothèques nécessaires
import 'package:flutter/material.dart';

// Classe représentant la page de récupération de mot de passe
class MotDePasseOubliePage extends StatelessWidget {
  // Contrôleur pour la saisie de l'adresse e-mail
  final TextEditingController _emailController = TextEditingController();

  // Méthode pour vérifier si l'adresse e-mail est valide
  bool _isEmailValid(String email) {
    // Expression régulière pour vérifier le format d'une adresse e-mail
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
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

  // Méthode pour soumettre le formulaire de récupération de mot de passe
  void _submitForm(BuildContext context) {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      _showErrorDialog(context, "Veuillez saisir une adresse mail.");
    } else if (!_isEmailValid(email)) {
      _showErrorDialog(context, "Veuillez saisir une adresse mail valide.");
    } else {
      // Code pour envoyer le code de récupération
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Code envoyé à $email'),
        ),
      );
    }
  }

  // Méthode pour construire l'interface utilisateur de la page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mot de Passe oublié',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
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
              Image.asset(
                'assets/images/logo.png',
                width: 300,
              ),
              const SizedBox(height: 20),
              const Text(
                'Mot de Passe oublié',
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
                  labelText: 'Adresse Email :',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _submitForm(context),
                child: const Text('Envoyer le code'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
