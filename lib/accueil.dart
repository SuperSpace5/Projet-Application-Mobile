// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'contact.dart';
import 'connexion.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Réservation Mobile-Home',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AccueilPage(),
    );
  }
}

class AccueilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/navigation/accueil.png', width: 20),
            const SizedBox(width: 8),
            const Text('Accueil',
                style: TextStyle(fontWeight: FontWeight.bold)),
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
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.lightBlueAccent,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: VideoPlayerWidget(),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              color: Colors.lightBlue,
              padding: const EdgeInsets.all(20),
              child: const Text(
                'Bienvenue sur notre application mobile !\n\nConnectez-vous pour avoir accès\n à votre Mobile-Home',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 19,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFd9edf7),
        items: [
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactPage()),
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
                  MaterialPageRoute(builder: (context) => ConnexionPage()),
                );
              },
              child:
                  Image.asset('assets/images/navigation/compte.png', width: 30),
            ),
            label: 'Connexion',
          ),
        ],
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/accueil.mp4')
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? VideoPlayer(_controller)
        : const CircularProgressIndicator();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
