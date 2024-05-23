// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exemple Flutter'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            print('Le bouton a été pressé !');
          },
          child: const Text('Appuyez sur moi'),
        ),
      ),
    );
  }
}
