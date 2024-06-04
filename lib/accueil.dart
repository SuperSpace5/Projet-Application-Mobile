import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'contact.dart';
import 'connexion.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Réservation Mobile-Home',
      theme: ThemeData(primarySwatch: Colors.blue),
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
      body: Stack(
        children: [
          Image.asset(
            'assets/images/fond_pages/couleur-ciel.jpeg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color:
                        Colors.white.withOpacity(0.8), // Fond blanc transparent
                    borderRadius: BorderRadius.circular(10), // Bords arrondis
                  ),
                  child: Image.asset('assets/images/logo.png', width: 300),
                ),
                const SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color:
                        Colors.white.withOpacity(0.8), // Fond blanc transparent
                    borderRadius: BorderRadius.circular(10), // Bords arrondis
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: VideoPlayerWidget(),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20), // Bords arrondis
                  ),
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
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFd9edf7),
        items: [
          navBarItem(context, 'assets/images/navigation/contact.png', 'Contact',
              ContactPage()),
          navBarItem(context, 'assets/images/navigation/compte.png',
              'Connexion', ConnexionPage()),
        ],
      ),
    );
  }

  BottomNavigationBarItem navBarItem(
      BuildContext context, String imagePath, String label, Widget page) {
    return BottomNavigationBarItem(
      icon: GestureDetector(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => page)),
        child: Image.asset(imagePath, width: 30),
      ),
      label: label,
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
