import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

void main() => runApp(MaterialApp(
      title: 'Ping Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PingTestPage(),
    ));

class PingTestPage extends StatefulWidget {
  @override
  _PingTestPageState createState() => _PingTestPageState();
}

class _PingTestPageState extends State<PingTestPage> {
  String _pingResult = '';

  Future<void> _testPing() async {
    try {
      final response = await http.get(Uri.parse('$apiUrlo/mobile/ping'));
      setState(() {
        _pingResult = response.statusCode == 200
            ? 'Ping réussi'
            : 'Échec du ping : ${response.statusCode}';
      });
    } catch (e) {
      setState(() {
        _pingResult = 'Échec du ping : $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test de Ping')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _testPing,
              child: const Text('Test Ping'),
            ),
            const SizedBox(height: 20),
            Text(
              _pingResult,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
