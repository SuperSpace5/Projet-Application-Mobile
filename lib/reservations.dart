// Importation du package flutter/material.dart qui contient les widgets pour construire l'interface utilisateur.
// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

// Fonction principale qui est exécutée au démarrage de l'application.
void main() {
  runApp(
      MyApp()); // Appel de la fonction runApp pour démarrer l'application avec le widget MyApp.
}

// Classe MyApp qui définit la structure de l'application.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retourne un widget MaterialApp qui représente l'application.
    return MaterialApp(
      // Titre de l'application affiché dans la barre de titre de l'OS.
      title: 'Mes réservations',
      // Thème de l'application.
      theme: ThemeData(
        // Couleur principale de l'application.
        primarySwatch: Colors.blue,
      ),
      // Page d'accueil de l'application.
      home: ReservationPage(),
    );
  }
}

// Énumération définissant les différents états de réservation.
enum EtatReservation {
  actif, // Réservation active.
  terminer, // Réservation terminée.
  annuler, // Réservation annulée.
}

// Classe représentant la page de réservation de l'application.
class ReservationPage extends StatelessWidget {
  // Liste des réservations.
  final List<Reservation> reservations = [
    Reservation(
      lieu: "Mobil Home - n°1",
      dateDebut: DateTime(2024, 04, 20),
      dateFin: DateTime(2024, 04, 25),
      etat: EtatReservation.terminer,
    ),
    Reservation(
      lieu: "Mobil Home - n°2",
      dateDebut: DateTime(2024, 06, 22),
      dateFin: DateTime(2024, 06, 27),
      etat: EtatReservation.actif,
    ),
    Reservation(
      lieu: "Mobil Home - n°3",
      dateDebut: DateTime(2024, 08, 05),
      dateFin: DateTime(2024, 08, 10),
      etat: EtatReservation.annuler,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Retourne un widget Scaffold qui définit la structure de base de la page.
    return Scaffold(
      // Barre d'applications de la page.
      appBar: AppBar(
        title: Row(
          children: [
            // Image affichée à gauche du titre.
            Image.asset('assets/images/navigation/compte.png', width: 20),
            const SizedBox(width: 8), // Espace entre l'image et le texte.
            const Text(
              'Mes réservations', // Texte du titre.
              style: TextStyle(fontWeight: FontWeight.bold), // Style du texte.
            ),
          ],
        ),
        backgroundColor: const Color(
            0xFFd9d9d9), // Couleur de fond de la barre d'applications.
      ),
      // Corps de la page contenant la liste des réservations.
      body: ListView.builder(
        itemCount: reservations.length, // Nombre d'éléments dans la liste.
        // Constructeur de chaque élément de la liste.
        itemBuilder: (context, index) {
          return Card(
            elevation: 2, // Élévation de la carte.
            margin: const EdgeInsets.symmetric(
                vertical: 8, horizontal: 16), // Marge de la carte.
            child: ListTile(
              // Élément de la liste représentant une réservation.
              title: Text(
                reservations[index].lieu, // Lieu de la réservation.
                style: const TextStyle(
                    fontWeight: FontWeight.bold), // Style du texte.
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // Texte affichant la période de la réservation.
                    'Du ${reservations[index].dateDebut.day.toString().padLeft(2, '0')}/${reservations[index].dateDebut.month.toString().padLeft(2, '0')}/${reservations[index].dateDebut.year} au ${reservations[index].dateFin.day.toString().padLeft(2, '0')}/${reservations[index].dateFin.month.toString().padLeft(2, '0')}/${reservations[index].dateFin.year}',
                  ),
                  Text(
                    // Texte affichant l'état de la réservation.
                    'État: ${_getTextEtat(reservations[index].etat)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getColorEtat(reservations[index].etat),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Méthode privée pour obtenir le texte de l'état de réservation.
  String _getTextEtat(EtatReservation etat) {
    switch (etat) {
      case EtatReservation.actif:
        return 'Actif';
      case EtatReservation.terminer:
        return 'Terminé';
      case EtatReservation.annuler:
        return 'Annulé';
    }
  }

  // Méthode privée pour obtenir la couleur de l'état de réservation.
  Color _getColorEtat(EtatReservation etat) {
    switch (etat) {
      case EtatReservation.actif:
        return Colors.green;
      case EtatReservation.terminer:
        return Colors.black;
      case EtatReservation.annuler:
        return Colors.red;
    }
  }
}

// Classe représentant une réservation.
class Reservation {
  final String lieu; // Lieu de la réservation.
  final DateTime dateDebut; // Date de début de la réservation.
  final DateTime dateFin; // Date de fin de la réservation.
  final EtatReservation etat; // État de la réservation.

  // Constructeur de la classe Reservation.
  Reservation({
    required this.lieu,
    required this.dateDebut,
    required this.dateFin,
    required this.etat,
  });
}
