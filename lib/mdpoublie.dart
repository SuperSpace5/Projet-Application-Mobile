import 'package:flutter/material.dart';

class MotDePasseOubliePage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  bool _isEmailValid(String email) =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.red,
        title: const Text(
          "Erreur",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          message,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
      ),
    );
  }

  void _submitForm(BuildContext context) {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      _showErrorDialog(context, "Veuillez saisir une adresse mail.");
    } else if (!_isEmailValid(email)) {
      _showErrorDialog(context, "Veuillez saisir une adresse mail valide.");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Code envoyé à $email')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mot de Passe oublié',
          style: TextStyle(fontWeight: FontWeight.bold),
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
                    color: Colors.black),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Adresse Email :'),
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
