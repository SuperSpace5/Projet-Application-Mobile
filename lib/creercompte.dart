import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'connexion.dart';
import 'config.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Créer un compte',
        theme: ThemeData(primarySwatch: Colors.green),
        home: CreerComptePage(),
      );
}

class CreerComptePage extends StatefulWidget {
  @override
  _CreerComptePageState createState() => _CreerComptePageState();
}

class _CreerComptePageState extends State<CreerComptePage> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;
  String genre = '';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Créer un compte',
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: const Color(0xFFd9d9d9),
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
                      offset: const Offset(0, 3)),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/logo.png', width: 300),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildGenderButton('M'),
                      const SizedBox(width: 20),
                      _buildGenderButton('F'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(_nomController, 'Nom :'),
                  const SizedBox(height: 10),
                  _buildTextField(_prenomController, 'Prénom :'),
                  const SizedBox(height: 10),
                  _buildTextField(_emailController, 'Adresse Email :',
                      keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 10),
                  _buildTextField(_numeroController, 'Numéro de Téléphone :',
                      keyboardType: TextInputType.phone),
                  const SizedBox(height: 10),
                  _buildPasswordTextField(
                      _passwordController, 'Mot de passe :'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Confirmer',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
            ),
          ),
        ),
      );

  ElevatedButton _buildGenderButton(String gender) => ElevatedButton(
        onPressed: () => setState(() => genre = gender),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(
                  color: genre == gender ? Colors.blue : Colors.black)),
        ),
        child: Text(
          gender,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: genre == gender ? Colors.blue : Colors.black),
        ),
      );

  TextField _buildTextField(TextEditingController controller, String labelText,
          {TextInputType keyboardType = TextInputType.text}) =>
      TextField(
        controller: controller,
        decoration: InputDecoration(labelText: labelText),
        keyboardType: keyboardType,
      );

  TextField _buildPasswordTextField(
          TextEditingController controller, String labelText) =>
      TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          suffixIcon: IconButton(
            icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => _showPassword = !_showPassword),
          ),
        ),
        obscureText: !_showPassword,
      );

  void _submitForm() async {
    final nom = _nomController.text.trim();
    final prenom = _prenomController.text.trim();
    final email = _emailController.text.trim();
    final numero = _numeroController.text.trim();
    final password = _passwordController.text.trim();
    final hashedPassword = _hashPassword(password);
    const apiUrl = '$apiUrlo/account/creationCompte_form';
    final resultCode = await _sendLoginForm(
        genre, nom, prenom, email, numero, hashedPassword, apiUrl);

    if ([genre, nom, prenom, email, numero, hashedPassword]
        .any((element) => element.isEmpty)) {
      _showErrorDialog(context, "Veuillez remplir tous les champs");
    }

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

  String _hashPassword(String password) =>
      sha256.convert(utf8.encode(password)).toString();

  Future<String> _sendLoginForm(String genre, String nom, String prenom,
      String email, String numero, String hashedPassword, String apiUrl) async {
    try {
      final response = await http.post(Uri.parse(apiUrl), body: {
        'genre': genre,
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'numero': numero,
        'password': hashedPassword,
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        return data["info"];
      } else {
        throw Exception(
            'Échec du chargement des données. Code d\'état : ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de l\'envoi du formulaire de connexion : $e');
      return '';
    }
  }

  void _showErrorDialog(BuildContext context, String message) => showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
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
        ),
      );

  void _showSuccessDialog(BuildContext context, String message) => showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: Colors.green,
          title: const Text("Succès",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: Text(message,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => ConnexionPage()));
              },
              child: const Text("OK",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
}
