// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, sort_child_properties_last, deprecated_member_use, avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';

enum EtatReservation {
  actif,
  terminer,
  confirmer,
  annuler,
}

class Reservation {
  final String lieu;
  final DateTime dateDebut;
  final DateTime dateFin;
  EtatReservation etat;

  Reservation({
    required this.lieu,
    required this.dateDebut,
    required this.dateFin,
    required this.etat,
  });
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mes réservations',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ReservationPage2(),
    );
  }
}

class ReservationPage2 extends StatefulWidget {
  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage2> {
  late List<Reservation> reservations;
  late List<String> availableMobileHomes;

  @override
  void initState() {
    super.initState();
    // Initialisation de la liste des réservations
    reservations = [];
    // Génération de la liste des mobil-homes disponibles
    availableMobileHomes =
        List.generate(10, (index) => "Mobile-Home - n°${index + 1}");
  }

  @override
  Widget build(BuildContext context) {
    _updateReservationStatus(); // Mettre à jour l'état des réservations chaque fois que la page est construite

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/navigation/reservation.png', width: 20),
            const SizedBox(width: 8),
            const Text(
              'Mes réservations',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFd9d9d9),
      ),
      body: ListView(
        children: [
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
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Active - La réservation est actuellement active',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Terminée - La réservation a été effectuée',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Confirmée - La réservation a été confirmée',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Annulée - La réservation a été annulée',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAvailableMobileHomesPopup(context);
        },
        child: const Icon(Icons.home),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _updateReservationStatus() {
    DateTime today = DateTime.now();
    reservations.forEach((reservation) {
      if (today.year == reservation.dateDebut.year &&
          today.month == reservation.dateDebut.month &&
          today.day == reservation.dateDebut.day &&
          reservation.etat == EtatReservation.confirmer) {
        setState(() {
          reservation.etat = EtatReservation.actif;
        });
      }
    });
  }

  void _showReservationDetails(BuildContext context, Reservation reservation) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        bool isConfirmed = reservation.etat == EtatReservation.confirmer;
        bool isFinished = reservation.etat == EtatReservation.terminer;
        bool isCancelled = reservation.etat == EtatReservation.annuler;

        return AlertDialog(
          title: Text(
            reservation.lieu,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Date de début : ${_getFullDate(reservation.dateDebut)}'),
                Text('Date de fin : ${_getFullDate(reservation.dateFin)}'),
                Text(
                  'État : ${_getTextEtat(reservation.etat)}\n',
                  style: TextStyle(
                    color: _getColorEtat(reservation.etat),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Réservation faite le : ${_getFullDate(DateTime.now())}',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            if (isConfirmed)
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Annuler la réservation"),
                      content: const Text(
                          "Êtes-vous sûr de vouloir annuler cette réservation ?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            _annulerReservation(reservation);
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          },
                          child: const Text("Oui"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Non"),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Annuler',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            if (isFinished || isCancelled)
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Supprimer la réservation"),
                      content: const Text(
                          "Êtes-vous sûr de vouloir supprimer cette réservation ?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            _supprimerReservation(reservation);
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          },
                          child: const Text("Oui"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Non"),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Supprimer',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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

  void _annulerReservation(Reservation reservation) {
    setState(() {
      reservation.etat = EtatReservation.annuler;
    });
  }

  void _supprimerReservation(Reservation reservation) {
    setState(() {
      reservations.remove(reservation);
    });
  }

  void _showAvailableMobileHomesPopup(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Mobil-Homes disponibles',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: availableMobileHomes.map((mobileHome) {
                return Column(
                  children: [
                    Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      color: _isMobileHomeAvailable(mobileHome)
                          ? Colors.lightGreen[200]
                          : Colors.grey[300],
                      child: ListTile(
                        title: Text(
                          'Numéro du Mobil-home : \n$mobileHome',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: _isMobileHomeAvailable(mobileHome)
                            ? () {
                                Navigator.pop(context);
                                _showReservationCalendarBottomSheet(
                                    context, mobileHome);
                              }
                            : null,
                      ),
                    ),
                    const Divider(),
                  ],
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Annuler',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showReservationCalendarBottomSheet(
      BuildContext context, String mobileHome) {
    DateTime? selectedStartDate;
    bool hasSelectedDates = false;

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                'Choisir la période de réservation pour $mobileHome',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date de début : ${selectedStartDate != null ? _getFullDate(selectedStartDate!) : "Non sélectionnée"}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2025),
                        ).then((pickedDate) {
                          if (pickedDate != null) {
                            setState(() {
                              selectedStartDate = pickedDate;
                              hasSelectedDates = true;
                            });
                          }
                        });
                      },
                      child: const Text('Sélectionner la date de début'),
                    ),
                    if (hasSelectedDates) ...[
                      Text(
                        'Date de fin : ${_getFullDate(selectedStartDate!.add(const Duration(days: 7)))}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showConfirmationPopup(
                              context,
                              mobileHome,
                              selectedStartDate!,
                              selectedStartDate!.add(const Duration(days: 7)));
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.orange),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        child: const Text(
                          'Confirmer la période',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Bouton "annuler"
                  },
                  child: const Text(
                    'Annuler',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showAvailableMobileHomesPopup(
                        context); // Bouton "précédent"
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: const Text('Précédent'),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showConfirmationPopup(BuildContext context, String mobileHome,
      DateTime startDate, DateTime endDate) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Détails de la réservation',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    mobileHome,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Période de réservation :',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Du ${_getFullDate(startDate)} au ${_getFullDate(endDate)}',
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    var newReservation = Reservation(
                      lieu: mobileHome,
                      dateDebut: startDate,
                      dateFin: endDate,
                      etat: EtatReservation.confirmer,
                    );
                    setState(() {
                      reservations.add(newReservation);
                    });
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Réservation Confirmée'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Valider',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.orange,
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.white,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Bouton "Précédent"
                    _showReservationCalendarBottomSheet(context, mobileHome);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: const Text('Précédent'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8), // Espacement entre les lignes de boutons
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Bouton "Annuler"
                },
                child: const Text(
                  'Annuler',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.red,
                  ),
                  foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  bool _isMobileHomeAvailable(String mobileHome) {
    return !reservations.any((reservation) =>
        reservation.lieu == mobileHome &&
        (reservation.etat == EtatReservation.actif ||
            reservation.etat == EtatReservation.confirmer));
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
