import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class ModelA extends ChangeNotifier {
  final List<Map<String, dynamic>> _dadosWaterTank = [];
  final List<Map<String, dynamic>> _dadosHidrometer = [];
  final List<Map<String, dynamic>> _dadosArtesianWell = [];
  Timer? _timer;

  List<Map<String, dynamic>> get dadosWaterTank => _dadosWaterTank;
  List<Map<String, dynamic>> get dadosHidrometer => _dadosHidrometer;
  List<Map<String, dynamic>> get dadosArtesianWell => _dadosArtesianWell;

  Map<String, dynamic> _lastSentWaterTank = {};

  Future<void> getHidrometer() async {
    const apiUrl = 'http://127.0.0.1:5000/api/data/Hidrometer';
    final url = Uri.parse(apiUrl);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        if (responseData['dados'] != null && responseData['dados'] is List) {
          _dadosHidrometer.clear();
          for (int i = 0; i < responseData['dados'].length && i < 8; i++) {
            var data = responseData['dados'][i];
            var dataCounter = data['data_counter'];
            if (dataCounter != null && dataCounter is List) {
              _dadosHidrometer.add({
                'nome': data['nome'] ?? 'N/A',
                'data_counter': dataCounter,
                'timestamp': data['timestamp'] ?? 'N/A',
              });
            } else {
              print('Warning: dataCounter is null or not a list for item $i');
            }
          }
        } else {
          print('Warning: dados is null or not a list');
        }
        notifyListeners();
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching Hidrometer data: $e');
      throw Exception('Failed to connect to the server. Error: $e');
    }
  }

  Future<void> getWaterTank() async {
    const apiUrl = 'http://127.0.0.1:5000/api/data/WaterTankLavel';
    final url = Uri.parse(apiUrl);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        if (responseData['dados'] != null && responseData['dados'] is List) {
          _dadosWaterTank.clear();
          for (int i = 0; i < responseData['dados'].length && i < 8; i++) {
            var data = responseData['dados'][i];
            var dataDistance = data['data_distance'];
            if (dataDistance != null && dataDistance is List) {
              _dadosWaterTank.add({
                'nome': data['nome'] ?? 'N/A',
                'data_distance': dataDistance,
                'timestamp': data['timestamp'] ?? 'N/A',
              });
            } else {
              print('Warning: data_distance is null or not a list for item $i');
            }
          }
        } else {
          print('Warning: dados is null or not a list');
        }
        notifyListeners();
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching WaterTank data: $e');
      throw Exception('Failed to connect to the server. Error: $e');
    }
  }

  Future<void> getArtesianWell() async {
    const apiUrl = 'http://127.0.0.1:5000/api/data/ArtesianWell';
    final url = Uri.parse(apiUrl);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        if (responseData['ArtesianWell'] != null &&
            responseData['ArtesianWell'] is Map) {
          var artesianWellData = responseData['ArtesianWell'];
          var dataPressure0 = artesianWellData['data_pressure_0'];
          var dataPressure1 = artesianWellData['data_pressure_1'];

          if (dataPressure0 != null &&
              dataPressure0 is List &&
              dataPressure1 != null &&
              dataPressure1 is List) {
            _dadosArtesianWell.clear();
            _dadosArtesianWell.add({
              'data_pressure_0': dataPressure0,
              'data_pressure_1': dataPressure1,
            });
          } else {
            print(
                'Warning: data_pressure_0 or data_pressure_1 is null or not a list');
          }
          notifyListeners();
        } else {
          print('Warning: ArtesianWell is null or not a Map');
        }
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching ArtesianWell data: $e');
      throw Exception('Failed to connect to the server. Error: $e');
    }
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) async {
      try {
        await getArtesianWell();
      } catch (e) {
        print('Error fetching ArtesianWell data: $e');
      }

      try {
        await getHidrometer();
      } catch (e) {
        print('Error fetching Hidrometer data: $e');
      }

      try {
        await getWaterTank();
      } catch (e) {
        print('Error fetching WaterTank data: $e');
      }

      if (_dadosWaterTank.isNotEmpty) {
        for (var item in _dadosWaterTank) {
          var nome = item['nome'];
          var timestampList = item['timestamp'];
          var dataDistance = item['data_distance'];

          for (int i = 0;
              i < timestampList.length && i < dataDistance.length;
              i++) {
            var timestamp = timestampList[i].toString();
            var distancia = dataDistance[i].toString();

            if (int.tryParse(distancia) != null && int.parse(distancia) < 60) {
              if (_lastSentWaterTank.containsKey(nome)) {
                var lastSent = _lastSentWaterTank[nome];
                if (lastSent['timestamp'] == timestamp &&
                    lastSent['distancia'] == distancia) {
                  continue;
                }
              }

              try {
                await enviaAlerta(nome, timestamp, distancia);
                _lastSentWaterTank[nome] = {
                  'timestamp': timestamp,
                  'distancia': distancia
                };
              } catch (e) {
                print('Error sending alert for $nome: $e');
              }
            }
          }
        }
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  Future<void> enviaAlerta(
      String nome, String timestamp, String distancia) async {
    final url = Uri.parse('http://127.0.0.1:8000/envia_alerta/');

    final Map<String, dynamic> body = {
      'nome': nome,
      'timestamp': timestamp,
      'distancia': distancia,
      'alarme': 60
    };
    print(body);
    final String jsonBody = json.encode(body);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Response data: $responseData');
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred while sending the alert: $e');
    }
  }
}

class EmailProvider with ChangeNotifier {
  String? _email;

  String? get email => _email;

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }
}
