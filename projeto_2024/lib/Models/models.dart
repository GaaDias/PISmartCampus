import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ModelA extends ChangeNotifier {
  final _dadosHidrometric1 = [];
  get dadosHidrometric1 => _dadosHidrometric1;

  final _dadosWaterTank1 = [];
  get dadosWaterTank1 => _dadosWaterTank1;

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
        _dadosHidrometric1.add({
          'nome': responseData['nodeName'],
          'tempo': responseData['time'],
          'data_counter': responseData['data_counter'],
          'data_boardVoltage': responseData['data_boardVoltage']
        });
        notifyListeners();

        // Print response data

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

    Future<Map<String, dynamic>> getWater1() async {
    const apiUrl = 'http://127.0.0.1:5000/api/data/WaterTankLavel/WaterTankLavel_1';

    final url = Uri.parse(apiUrl);

    try {
      // Send a GET request to the server
      final response = await http.get(url);

      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        // Parse the response body as JSON
        var responseData = json.decode(response.body);

        // Add user data to a list (assuming _usuarios is a list field in your class)
        _dadosWaterTank1.add({
          'nome': responseData['nodeName'],
          'tempo': responseData['time'],
          'data_distance': responseData['data_distance'],
          'data_boardVoltage': responseData['data_boardVoltage']
        });
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









}
