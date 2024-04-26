// Importations de packages et de fichiers locaux
// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart'; // Package Flutter pour la création d'interfaces utilisateur
import 'package:video_player/video_player.dart'; // Package pour la lecture de vidéos
import 'contact.dart'; // Fichier contenant la page de contact
import 'connexion.dart'; // Fichier contenant la page de connexion

// Fonction principale, point d'entrée de l'application
void main() {
  runApp(MyApp()); // Appel de la fonction runApp avec l'instance de MyApp
}

// Classe MyApp, représentant l'application Flutter
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Réservation Mobile-Home', // Titre de l'application
      theme: ThemeData(
        primarySwatch: Colors.blue, // Thème de couleur principal
      ),
      home: AccueilPage(), // Page d'accueil de l'application
    );
  }
}

// Classe AccueilPage, représentant la page d'accueil de l'application
class AccueilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/navigation/accueil.png',
                width: 20), // Ajout de l'icône de l'accueil à gauche du titre
            const SizedBox(width: 8), // Espacement entre l'icône et le titre
            const Text('Accueil',
                style: TextStyle(
                    fontWeight: FontWeight.bold)), // Mise en gras du titre
          ],
        ),
        backgroundColor: const Color(0xFFd9d9d9), // Couleur de l'AppBar
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Image.asset('assets/images/logo.png',
                width: 300), // Affichage du logo
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.lightBlueAccent,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child:
                    VideoPlayerWidget(), // Widget pour la lecture de la vidéo
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Bienvenue sur notre application mobile !\n\nConnectez-vous pour avoir accès\n à votre Mobile-Home',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 19,
                  color: Colors.black,
                  fontWeight: FontWeight.bold), // Mise en gras du texte
            ),
            const SizedBox(height: 20),
            // Ajouter le reste du contenu ici
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:
            const Color(0xFFd9edf7), // Couleur du bas de la navigation
        items: [
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ContactPage()), // Navigation vers la page de contact
                );
              },
              child: Image.asset('assets/images/navigation/contact.png',
                  width: 30), // Icône pour la page de contact
            ),
            label: 'Contact', // Libellé de l'élément de navigation
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ConnexionPage()), // Navigation vers la page de connexion
                );
              },
              child: Image.asset('assets/images/navigation/compte.png',
                  width: 30), // Icône pour la page de connexion
            ),
            label: 'Connexion', // Libellé de l'élément de navigation
          ),
        ],
      ),
    );
  }
}

// Classe VideoPlayerWidget, un StatefulWidget pour la lecture de vidéos
class VideoPlayerWidget extends StatefulWidget {
  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

// Classe _VideoPlayerWidgetState, état du widget VideoPlayerWidget
class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController
      _controller; // Contrôleur pour la lecture de la vidéo

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
        'assets/videos/accueil.mp4') // Chemin de la vidéo à lire
      ..initialize().then((_) {
        // Démarrer automatiquement la lecture une fois la vidéo initialisée
        _controller.play();
        // Configurer la boucle infinie de la vidéo
        _controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? VideoPlayer(_controller) // Widget pour afficher la vidéo
        : const CircularProgressIndicator(); // Indicateur de chargement si la vidéo n'est pas initialisée
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose(); // Libération des ressources du contrôleur vidéo
  }
}
