// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NfcReaderPage(),
    );
  }
}

class NFCPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page NFC'),
      ),
      body: const Center(
        child: Text('Contenu de la page NFC'),
      ),
    );
  }
}

class NfcReaderPage extends StatefulWidget {
  @override
  _NfcReaderPageState createState() => _NfcReaderPageState();
}

class _NfcReaderPageState extends State<NfcReaderPage> {
  String _nfcData = 'Aucune donnée NFC lue pour le moment';
  bool _showWaitingPopup = false; // Ajout de l'état pour afficher la pop-up

  @override
  void initState() {
    super.initState();
    _startNfcSession();
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  Future<void> _startNfcSession() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (!isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('NFC n\'est pas disponible sur cet appareil')),
      );
      return;
    }

    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        setState(() {
          _nfcData = tag.data.toString();
          _showWaitingPopup =
              false; // Cacher la pop-up lorsque le badge est détecté
        });
      },
    ).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la lecture NFC: $e')),
      );
      throw e; // Lancez une exception pour respecter le type de retour 'Future<void>'
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lecteur NFC'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_showWaitingPopup)
              const AlertDialog(
                title: Text("Attente lecture badge NFC"),
                content: CircularProgressIndicator(), // Contenu de la pop-up
              ),
            Text(_nfcData),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showWaitingPopup = true; // Afficher la pop-up d'attente
          });
          _startNfcSession();
        },
        child: const Icon(Icons.nfc),
      ),
    );
  }
}
