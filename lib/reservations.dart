import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'config.dart'; // Assurez-vous que ce fichier contient la variable apiUrlo

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

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      lieu: json['lieu'],
      dateDebut: DateTime.parse(json['dateDebut']),
      dateFin: DateTime.parse(json['dateFin']),
      etat: EtatReservation.values[json['etat']],
    );
  }
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
    reservations = [];
    availableMobileHomes =
        List.generate(10, (index) => "Mobile-Home - n°${index + 1}");
    _fetchReservations(); // Fetch reservations when the app starts
  }

  @override
  Widget build(BuildContext context) {
    _updateReservationStatus();

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
                        const SizedBox(height: 8), // Espacement
                        const Text(
                          'Informations de réservation : ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Lieu: ${reservations[index].lieu}',
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Date de début: ${reservations[index].dateDebut}',
                              ),
                              Text(
                                'Date de fin: ${reservations[index].dateFin}',
                              ),
                              Text(
                                'État: ${_getTextEtat(reservations[index].etat)}',
                                style: TextStyle(
                                  color:
                                      _getColorEtat(reservations[index].etat),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _fetchReservations,
              child: const Text('Récupérer les réservations'),
            ),
          ),
        ],
      ),
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

  Future<void> _fetchReservations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      print('Token non trouvé');
      return;
    }

    String apiUrl = apiUrlo + "/mobile/Reservation";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'Token': token}),
      );

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        if (responseJson['info'] is List) {
          final List<dynamic> reservationsJson = responseJson['info'];
          setState(() {
            reservations = reservationsJson
                .map((json) => Reservation.fromJson(json))
                .toList();
          });
        } else {
          print(responseJson['info']);
        }
      } else {
        print(
            'Erreur lors de la récupération des réservations: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur réseau: $e');
    }
  }

  void _showReservationDetails(BuildContext context, Reservation reservation) {
    // Reste du code de votre méthode _showReservationDetails
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
    // Reste du code de votre méthode _showAvailableMobileHomesPopup
  }

  void _showReservationCalendarBottomSheet(
      BuildContext context, String mobileHome) {
    // Reste du code de votre méthode _showReservationCalendarBottomSheet
  }

  void _showConfirmationPopup(BuildContext context, String mobileHome,
      DateTime startDate, DateTime endDate) {
    // Reste du code de votre méthode _showConfirmationPopup
  }

  bool _isMobileHomeAvailable(String mobileHome) {
    return !reservations.any((reservation) =>
        reservation.lieu == mobileHome &&
        (reservation.etat == EtatReservation.actif ||
            reservation.etat == EtatReservation.confirmer));
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
      default:
        return '';
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
      default:
        return Colors.black;
    }
  }
}
