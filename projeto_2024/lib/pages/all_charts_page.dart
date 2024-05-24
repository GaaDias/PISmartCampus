import 'package:flutter/material.dart';
import 'package:projeto_2024/Models/models.dart';
import 'package:projeto_2024/components/appbar.dart';
import 'package:projeto_2024/components/card_all.dart';

class AllChartsPage extends StatefulWidget {
  const AllChartsPage({super.key});

  @override
  State<AllChartsPage> createState() => _AllChartsPageState();
}

ModelA modelA = ModelA();

class _AllChartsPageState extends State<AllChartsPage> {
  var corBotao;
  double? wvalue = 300;
  double? hvalue = 260;
  List<double> percentages = [];

  @override
  void initState() {
    super.initState();
    modelA.getHidrometer().then((_) {
      // Update percentages list with last values
      updatePercentages();
      setState(() {}); // Trigger rebuild
    }).catchError((error) {
      print("Error fetching data: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyAppBar(
      myBody: Center(
        child: modelA.dadosHidrometer.isEmpty
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildRow([0, 1, 2, 3]),
                  buildRow([4, 5, 6, 7]),
                ],
              ),
      ),
    );
  }

  // Function to update percentages list with last values
  void updatePercentages() {
    percentages.clear(); // Clear the list before updating
    for (int i = 0; i < modelA.dadosHidrometer.length; i++) {
      percentages.add(getLastValueFromHidrometer(modelA, i));
    }
  }

  Row buildRow(List<int> indices) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: indices.map((index) {
        double lastValue =
            (percentages.length > index) ? percentages[index] : 0.0;
        double percentage = (lastValue / 5500) * 100; // Calculate percentage
        return CardAll(
          hvalue: hvalue,
          wvalue: wvalue,
          index: index,
          percentage: percentage,
        );
      }).toList(),
    );
  }

  double getLastValueFromHidrometer(ModelA modelA, int index) {
    if (modelA.dadosHidrometer.isNotEmpty &&
        modelA.dadosHidrometer[index]['data_counter'] != null &&
        (modelA.dadosHidrometer[index]['data_counter'] as List).isNotEmpty) {
      List<dynamic> dataCounter =
          modelA.dadosHidrometer[index]['data_counter'] as List<dynamic>;
      return (dataCounter.last as num).toDouble();
    } else {
      return 0.0; // Return a default value if no data is available
    }
  }
}
