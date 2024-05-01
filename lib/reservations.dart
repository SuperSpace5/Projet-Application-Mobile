// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, sort_child_properties_last, unused_element

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
      home: ReservationPage(),
    );
  }
}

class ReservationPage extends StatefulWidget {
  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  late List<Reservation> reservations;
  late List<String> availableMobileHomes;

  @override
  void initState() {
    super.initState();
    reservations = [
      Reservation(
        lieu: "Mobile-Home - n°1",
        dateDebut: DateTime(2024, 04, 20),
        dateFin: DateTime(2024, 04, 25),
        etat: EtatReservation.terminer,
      ),
      Reservation(
        lieu: "Mobile-Home - n°2",
        dateDebut: DateTime(2024, 06, 22),
        dateFin: DateTime(2024, 06, 27),
        etat: EtatReservation.actif,
      ),
      Reservation(
        lieu: "Mobile-Home - n°3",
        dateDebut: DateTime(2024, 07, 08),
        dateFin: DateTime(2024, 07, 15),
        etat: EtatReservation.confirmer,
      ),
      Reservation(
        lieu: "Mobile-Home - n°4",
        dateDebut: DateTime(2024, 08, 05),
        dateFin: DateTime(2024, 08, 10),
        etat: EtatReservation.annuler,
      ),
      Reservation(
        lieu: "Mobile-Home - n°5",
        dateDebut: DateTime(2024, 08, 21),
        dateFin: DateTime(2024, 08, 28),
        etat: EtatReservation.confirmer,
      ),
    ];

    availableMobileHomes =
        List.generate(10, (index) => "Mobile-Home - n°${index + 1}");
  }

  @override
  Widget build(BuildContext context) {
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
                  'Réservation faite le : ${_getFullDate(DateTime(2024, 01, 17))}',
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
            'Mobil Homes disponibles',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: availableMobileHomes.map((mobileHome) {
                bool isReserved = reservations.any((reservation) =>
                    reservation.lieu == mobileHome &&
                    (reservation.etat == EtatReservation.actif ||
                        reservation.etat == EtatReservation.confirmer));
                if (!isReserved) {
                  return Column(
                    children: [
                      Material(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        color: Colors.lightGreen[200],
                        child: ListTile(
                          title: Text(
                            mobileHome,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            _showReservationCalendarBottomSheet(
                                context, mobileHome);
                          },
                        ),
                      ),
                      const Divider(),
                    ],
                  );
                } else {
                  return Container();
                }
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _showReservationCalendarBottomSheet(
      BuildContext context, String mobileHome) {
    DateTime? selectedStartDate;

    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choisir la période de réservation pour $mobileHome',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Date de début : ${selectedStartDate != null ? _getFullDate(selectedStartDate!) : "Non sélectionnée"}',
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
                          });
                        }
                      });
                    },
                    child: const Text('Sélectionner la date de début'),
                  ),
                  const SizedBox(height: 16),
                  if (selectedStartDate != null) ...[
                    Text(
                      'Date de fin : ${_getFullDate(selectedStartDate!.add(const Duration(days: 7)))}',
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // La période est sélectionnée, vous pouvez traiter ici
                        print(
                            'Période sélectionnée : $selectedStartDate - ${selectedStartDate!.add(const Duration(days: 7))}');
                        Navigator.pop(context);
                      },
                      child: const Text('Confirmer la période'),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  bool _isPeriodAvailable(
      String mobileHome, DateTime startDate, DateTime endDate) {
    return !reservations.any((reservation) =>
        reservation.lieu == mobileHome &&
        ((startDate.isBefore(reservation.dateFin) &&
                startDate.isAfter(reservation.dateDebut)) ||
            (endDate.isBefore(reservation.dateFin) &&
                endDate.isAfter(reservation.dateDebut))));
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
