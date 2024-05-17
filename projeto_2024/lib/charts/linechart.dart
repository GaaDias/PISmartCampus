import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:projeto_2024/Models/models.dart';

class MyLineChart extends StatefulWidget {
  MyLineChart({Key? key}) : super(key: key);

  @override
  State<MyLineChart> createState() => _MyLineChartState();
}

List<FlSpot> generateFlSpots(ModelA modelA) {
  List<FlSpot> spots = [];

  if (modelA.dadosWaterTank.isNotEmpty) {
    List<dynamic>? dataCounter =
        modelA.dadosWaterTank[0]['data_distance'] as List<dynamic>?;

    if (dataCounter != null) {
      for (int i = 0; i < dataCounter.length && i <= 15; i++) {
        spots.add(FlSpot(i.toDouble(), dataCounter[i].toDouble()));
      }
    } else {
      for (int i = 0; i <= 15; i++) {
        spots.add(FlSpot(i.toDouble(), 0.0));
      }
    }
  } else {
    for (int i = 0; i <= 15; i++) {
      spots.add(FlSpot(i.toDouble(), 0.0));
    }
  }

  print('Generated spots: $spots'); // Debug statement
  return spots;
}

class _MyLineChartState extends State<MyLineChart> {
  ModelA modelA = ModelA();

  @override
  void initState() {
    super.initState();
    // Call getHidro1() here to fetch data when the widget is initialized
    modelA.getHidro1().then((_) {
      // Update the UI after data is fetched
      setState(() {}); // Trigger rebuild
    }).catchError((error) {
      // Handle error if necessary
      print("Error fetching data: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return modelA.dadosWaterTank.isNotEmpty
        ? buildChart()
        : buildLoadingIndicator();
  }

  Widget buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(), // Show loading indicator
    );
  }

  Widget buildChart() {
    List<dynamic>? dataCounter =
        modelA.dadosWaterTank[0]['data_distance'] as List<dynamic>?;

    print('Building chart with dataCounter: $dataCounter'); // Debug statement

    return Container(
      height: 260,
      width: 500,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.only(left: 10, bottom: 10, right: 40, top: 40),
      child: LineChart(
        LineChartData(
          minX: 0,
          minY: 0,
          maxX: 15,
          maxY: dataCounter != null && dataCounter.isNotEmpty
              ? dataCounter
                  .reduce((value, element) => value > element ? value : element)
                  .toDouble()
              : 1.0,
          lineBarsData: [
            LineChartBarData(
              spots: generateFlSpots(modelA),
              isCurved: false,
              dotData: FlDotData(
                show: false,
              ),
            ),
          ],
          borderData: FlBorderData(
              border: const Border(bottom: BorderSide(), left: BorderSide())),
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
        ),
      ),
    );
  }
}
