// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, file_names

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

class NfcReaderPage extends StatefulWidget {
  @override
  _NfcReaderPageState createState() => _NfcReaderPageState();
}

class _NfcReaderPageState extends State<NfcReaderPage> {
  String _nfcData = 'Aucune donnée NFC lue pour le moment';
  bool _showWaitingPopup = false;
  bool _showNfcButton = false;
  bool _showCommunicationPopup = false;

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
          content: Text('NFC n\'est pas disponible sur cet appareil'),
        ),
      );
      return;
    }

    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        setState(() {
          _nfcData = tag.data.toString();
          _showWaitingPopup = false;
          _showNfcButton = true;
        });
      },
    ).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la lecture NFC: $e')),
      );
      throw e;
    });
  }

  Future<void> _communicateWithNfcSensor(String nfcData) async {
    setState(() {
      _showCommunicationPopup = true;
    });
    await Future.delayed(const Duration(
        seconds: 99)); // Simule la communication pendant 99 secondes
    setState(() {
      _showCommunicationPopup = false;
      _showWaitingPopup = true;
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
            if (_showWaitingPopup || _showCommunicationPopup)
              AlertDialog(
                title: Text(_showWaitingPopup
                    ? "Attente lecture badge NFC"
                    : "Attente communication NFC"),
                content: const CircularProgressIndicator(),
              ),
            Text(_nfcData),
            if (_showNfcButton)
              FloatingActionButton(
                onPressed: () => _communicateWithNfcSensor(_nfcData),
                child: const Icon(Icons.send),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showWaitingPopup = true;
            _showNfcButton = false;
          });
          _startNfcSession();
        },
        child: const Icon(Icons.nfc),
      ),
    );
  }
}
