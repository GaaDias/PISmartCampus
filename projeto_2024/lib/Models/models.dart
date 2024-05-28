import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ModelA extends ChangeNotifier {
  final List<Map<String, dynamic>> _dadosWaterTank = [];
  List<Map<String, dynamic>> get dadosWaterTank => _dadosWaterTank;

  final List<Map<String, dynamic>> _dadosHidrometer = [];
  List<Map<String, dynamic>> get dadosHidrometer => _dadosHidrometer;

  final List<Map<String, dynamic>> _dadosArtesianWell = [];
  List<Map<String, dynamic>> get dadosArtesianWell => _dadosArtesianWell;

  Future<Map<String, dynamic>> getHidrometer() async {
    const apiUrl = 'http://127.0.0.1:5000/api/data/Hidrometer';

    final url = Uri.parse(apiUrl);

    try {
      // Send a GET request to the server
      final response = await http.get(url);

      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        // Parse the response body as JSON
        var responseData = json.decode(response.body);
        // print('API Response: $responseData'); // Debug statement

        // Check if responseData['dados'] is not null and is a List
        if (responseData['dados'] != null && responseData['dados'] is List) {
          for (int i = 0; i < responseData['dados'].length && i < 8; i++) {
            var data = responseData['dados'][i];

            // Ensure data_distance is a list and is not null
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

        // Return the response data
        return responseData;
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle errors during the HTTP request
      print('Error: $e');
      throw Exception('Failed to connect to the server. Error: $e');
    }
  }

  Future<Map<String, dynamic>> getWaterTank() async {
    const apiUrl = 'http://127.0.0.1:5000/api/data/WaterTankLavel';

    final url = Uri.parse(apiUrl);

    try {
      // Send a GET request to the server
      final response = await http.get(url);

      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        // Parse the response body as JSON
        var responseData = json.decode(response.body);
        // print('API Response: $responseData'); // Debug statement

        // Check if responseData['dados'] is not null and is a List
        if (responseData['dados'] != null && responseData['dados'] is List) {
          for (int i = 0; i < responseData['dados'].length && i < 8; i++) {
            var data = responseData['dados'][i];

            // Ensure data_distance is a list and is not null
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

        // Return the response data
        return responseData;
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle errors during the HTTP request
      print('Error: $e');
      throw Exception('Failed to connect to the server. Error: $e');
    }
  }

  Future<Map<String, dynamic>> getArtesianWell() async {
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
            _dadosArtesianWell.clear(); // Clear previous data
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

        return responseData;
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to connect to the server. Error: $e');
    }
  }
}
