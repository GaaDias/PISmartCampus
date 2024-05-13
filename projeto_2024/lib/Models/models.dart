import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ModelA extends ChangeNotifier {
  final _dados = [];

  get dados => _dados;
  Future<Map<String, dynamic>> getHidro1() async {
    const apiUrl = 'http://127.0.0.1:5000/api/data/Hidrometer/Hidrometer_1';

    final url = Uri.parse(apiUrl);

    try {
      // Send a GET request to the server
      final response = await http.get(url);

      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        // Parse the response body as JSON
        var responseData = json.decode(response.body);

        // Add user data to a list (assuming _usuarios is a list field in your class)
        _dados.add({
          'nome': responseData['nodeName'],
          'tempo': responseData['time'],
          'data_counter': responseData['data_counter'],
          'data_boardVoltage': responseData['data_boardVoltage']
        });
        notifyListeners();

        // Print response data

        print(dados[0]['data_counter'][3]);

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
}
