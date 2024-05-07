// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'pageprotest.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _handleLogin() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      await login(email, password);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePageTest()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _handleLogin,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> login(String email, String password) async {
  final response = await http.post(
    Uri.parse('http://192.168.95.84:8080/account/mobile/login_form_mobile'),
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: <String, String>{
      'email': email,
      'password': password,
    },
  );

  if (response.statusCode == 200) {
    // Si le serveur retourne une réponse OK, parsez le JSON.
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    // Vérifiez le code d'erreur.
    if (jsonResponse['info'] == '0102') {
      print('Authentification réussie.');

      // Stockez le cookie de session dans les préférences partagées.
      String? sessionCookie = response.headers['set-cookie'];
      if (sessionCookie != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('sessionCookie', sessionCookie);
      }
    } else if (jsonResponse['info'] == '0103') {
      print('Erreur d\'authentification.');
      throw Exception('Failed to login.');
    }
  } else {
    // Si cette réponse n'est pas OK, lancez une exception.
    throw Exception('Failed to login.');
  }
}
