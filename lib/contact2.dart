import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Réservation Mobile-Home',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ContactPage2(),
    );
  }
}

class ContactPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/navigation/contact.png', width: 20),
            const SizedBox(width: 8),
            const Text(
              'Contact',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFd9d9d9),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Image.asset('assets/images/logo.png', width: 300),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'En cas de problèmes, veuillez nous contacter via :',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Adresse E-mail : mobilehomeparadis@gmail.com\n\nTéléphone : 06.85.85.85.85\n\nAdresse Camping : 123 Rue des Mobiles Homes, 11170 Gruissan',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Image.asset('assets/images/contact/tour.jpg', width: 375),
          ],
        ),
      ),
    );
  }
}
