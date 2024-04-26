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
  confirmer, // Réservation confirmée.
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
      dateDebut: DateTime(2024, 07, 08),
      dateFin: DateTime(2024, 07, 15),
      etat: EtatReservation.confirmer,
    ),
    Reservation(
      lieu: "Mobil Home - n°4",
      dateDebut: DateTime(2024, 08, 05),
      dateFin: DateTime(2024, 08, 10),
      etat: EtatReservation.annuler,
    ),
  ];

  Future<void> _showReservationDetails(
      BuildContext context, Reservation reservation) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            reservation.lieu, // Modifiez cette ligne
            style: const TextStyle(
                fontWeight: FontWeight.bold), // Ajoutez cette ligne
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Date de début : ${_getFullDate(reservation.dateDebut)}'), // Modifiez cette ligne
                Text(
                    'Date de fin : ${_getFullDate(reservation.dateFin)}'), // Modifiez cette ligne
                Text(
                  'État : ${_getTextEtat(reservation.etat)}\n', // Modifiez cette ligne
                  style: TextStyle(
                    color: _getColorEtat(reservation.etat),
                    fontWeight: FontWeight.bold, // Ajoutez cette ligne
                  ),
                ),
                Text(
                  'Réservation faite le : ${_getFullDate(DateTime(2024, 01, 17))}', // Ajoutez cette ligne
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red, // Couleur de fond rouge
                  borderRadius: BorderRadius.circular(8), // Bords arrondis
                ),
                padding: const EdgeInsets.all(
                    10), // Espacement intérieur du container
                child: const Text(
                  'Annuler',
                  style: TextStyle(
                    color: Colors.white, // Couleur du texte en blanc
                    fontWeight: FontWeight.bold, // Police en gras
                  ),
                ),
              ),
              onPressed: () {
                // Action à effectuer lors de l'annulation
              },
            ),
            TextButton(
              child: const Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _getFullDate(DateTime date) {
    final days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    final months = [
      'Jan',
      'Fév',
      'Mar',
      'Avr',
      'Mai',
      'Juin',
      'Juil',
      'Août',
      'Sept',
      'Oct',
      'Nov',
      'Déc'
    ];
    return '${days[date.weekday - 1]} ${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    // Retourne un widget Scaffold qui définit la structure de base de la page.
    return Scaffold(
      // Barre d'applications de la page.
      appBar: AppBar(
        title: Row(
          children: [
            // Image affichée à gauche du titre.
            Image.asset('assets/images/navigation/reservation.png', width: 20),
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
      body: Column(
        children: [
          // Case de lexique
          const Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    'Lexique des états de réservation : ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Actif - La réservation est actuellement active',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Terminé - La réservation a été effectuée',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Confirmé - La réservation a été confirmée',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Annulé - La réservation a été annulée',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
          // Liste des réservations
          Expanded(
            child: ListView.builder(
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _showReservationDetails(context, reservations[index]);
                  },
                  child: Card(
                    elevation: 2,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(
                        reservations[index].lieu,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Du ${reservations[index].dateDebut.day.toString().padLeft(2, '0')}/${reservations[index].dateDebut.month.toString().padLeft(2, '0')}/${reservations[index].dateDebut.year} au ${reservations[index].dateFin.day.toString().padLeft(2, '0')}/${reservations[index].dateFin.month.toString().padLeft(2, '0')}/${reservations[index].dateFin.year}',
                          ),
                          Text(
                            'État: ${_getTextEtat(reservations[index].etat)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _getColorEtat(reservations[index].etat),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Méthode privée pour obtenir le texte de l'état de réservation.
  String _getTextEtat(EtatReservation etat) {
    switch (etat) {
      case EtatReservation.actif:
        return 'Active';
      case EtatReservation.terminer:
        return 'Terminée';
      case EtatReservation.confirmer:
        return 'Confirmée';
      case EtatReservation.annuler:
        return 'Annulée';
    }
  }

  // Méthode privée pour obtenir la couleur de l'état de réservation.
  Color _getColorEtat(EtatReservation etat) {
    switch (etat) {
      case EtatReservation.actif:
        return Colors.green;
      case EtatReservation.terminer:
        return Colors.black;
      case EtatReservation.confirmer:
        return Colors.orange;
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
