import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'config.dart';

void main() {
  runApp(MyApp());
}

class Reservation {
  final int id;
  final String startDate;
  final String endDate;
  final String porteCode;
  bool isActive;

  Reservation({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.porteCode,
    required this.isActive,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] ?? 0,
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      porteCode: json['code_porte'] ?? '',
      isActive: json['Actif'] == 1,
    );
  }

  String getFormattedStartDate() {
    DateTime parsedDate = DateTime.parse(startDate);
    return DateFormat('dd-MM-yyyy à HH:mm:ss').format(parsedDate);
  }

  String getFormattedEndDate() {
    DateTime parsedDate = DateTime.parse(endDate);
    return DateFormat('dd-MM-yyyy à HH:mm:ss').format(parsedDate);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Page de Réservation',
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
  List<Reservation> _reservations = [];

  @override
  void initState() {
    super.initState();
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
      final response = await Dio().post(
        apiUrl,
        data: jsonEncode({'Token': token}),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        final responseJson = response.data;
        if (responseJson is List) {
          setState(() {
            _reservations =
                responseJson.map((json) => Reservation.fromJson(json)).toList();
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

  Future<void> updateAccountReservation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      print('Token non trouvé');
      return;
    }

    try {
      final response = await Dio().post(
        apiUrlo + "/mobile/Reservation",
        data: jsonEncode({'Token': token}),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      if (response.statusCode == 200) {
        _reservations.clear();
        final userReservationsJson =
            jsonDecode(response.data['info'].toString());
        for (int i = 0; i < userReservationsJson.length; i++) {
          Reservation reservation = Reservation(
            id: userReservationsJson[i]['id'],
            startDate: userReservationsJson[i]['start_date'],
            endDate: userReservationsJson[i]['end_date'],
            porteCode: userReservationsJson[i]['code_porte'],
            isActive: userReservationsJson[i]['Actif'] == 1 ? true : false,
          );
          _reservations.add(reservation);
        }
        setState(() {});
        print(_reservations);
      }
    } catch (e) {
      print(
          'Erreur lors de la mise à jour des réservations du compte utilisateur: $e');
    }
  }

  Future<void> _cancelReservation(String startDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      print('Token non trouvé');
      return;
    }

    String apiUrl = apiUrlo + "/mobile/Reservation/Annulation";

    try {
      final response = await Dio().post(
        apiUrl,
        data: jsonEncode({'Token': token, 'start_date': startDate}),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        final responseJson = response.data;
        if (responseJson['info'] == '0405') {
          setState(() {
            for (var reservation in _reservations) {
              if (reservation.startDate == startDate) {
                reservation.isActive = false;
                break;
              }
            }
          });
          _showDialog('Annulation réussie');
        } else {
          _showDialog('Erreur: ${responseJson['info']}');
        }
      } else {
        _showDialog('Erreur lors de l\'annulation: ${response.statusCode}');
      }
    } catch (e) {
      _showDialog('Erreur réseau: $e');
    }
  }

  void _showDialog(String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button to close the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notification'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showCancelConfirmationDialog(String startDate) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Annuler la réservation'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Voulez-vous vraiment annuler la réservation ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Non'),
            ),
            TextButton(
              onPressed: () {
                _cancelReservation(startDate);
                Navigator.of(context).pop();
              },
              child: const Text('Oui'),
            ),
          ],
        );
      },
    );
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
              'Réservations',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFd9d9d9),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/fond_pages/vh.jpg',
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _fetchReservations();
                    updateAccountReservation();
                  },
                  child: const Text(
                    'Actualiser',
                    style: TextStyle(fontSize: 18), // Taille du texte agrandie
                  ),
                ),
                _buildReservationList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationList() {
    if (_reservations.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text('Aucune réservation à afficher'),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _reservations.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (context, index) {
        final reservation = _reservations[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Réservation ${index + 1}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Du ${reservation.getFormattedStartDate()}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  'au ${reservation.getFormattedEndDate()}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                if (reservation.isActive)
                  Text(
                    'Code Porte : ${reservation.porteCode}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  reservation.isActive ? 'Active' : 'Annulée',
                  style: TextStyle(
                    fontSize: 16,
                    color: reservation.isActive ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                if (reservation.isActive)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => _showCancelConfirmationDialog(reservation
                        .startDate), // Appel de la popup de confirmation
                    child: const Text(
                      'Annuler',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
