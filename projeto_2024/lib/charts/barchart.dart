import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:projeto_2024/Models/models.dart';
import 'package:projeto_2024/colors/colors.dart';
import 'package:provider/provider.dart';

class MyBarChart extends StatefulWidget {
  final int index;
  const MyBarChart({super.key, required this.index});

  @override
  State<MyBarChart> createState() => _MyBarChartState();
}

class BarChartDataAndTimestamps {
  List<BarChartGroupData> barGroups;
  List<String> timestamps;

  BarChartDataAndTimestamps(this.barGroups, this.timestamps);
}

BarChartDataAndTimestamps generateBarGroups(ModelA modelA, int index) {
  List<BarChartGroupData> barGroups = [];
  List<String> timestamps = [];

  if (modelA.dadosHidrometer.isNotEmpty) {
    List<dynamic>? dataHidro =
        modelA.dadosHidrometer[index]['data_counter'] as List<dynamic>?;
    List<dynamic>? timestampsData =
        modelA.dadosHidrometer[index]['timestamp'] as List<dynamic>?;

    if (dataHidro != null && timestampsData != null) {
      int length = dataHidro.length;

      for (int i = 0; i < length; i++) {
        barGroups.add(
          BarChartGroupData(
            x: i, // adjust x to match the index
            barRods: [
              BarChartRodData(
                toY: dataHidro[i].toDouble(),
                color: azulPadrao,
                width: 5,
              )
            ],
          ),
        );
        String timestamp = timestampsData[i].toString();
        timestamps.add(
            timestamp.substring(timestamp.length - 8)); // get last 8 characters
      }
    } else {
      for (int i = 0; i < 15; i++) {
        barGroups.add(
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: 0.0,
                color: Colors.blue,
                width: 5,
              )
            ],
          ),
        );
        timestamps.add('');
      }
    }
  } else {
    for (int i = 0; i < 15; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: 0.0,
              color: Colors.blue,
              width: 5,
            )
          ],
        ),
      );
      timestamps.add('');
    }
  }

  return BarChartDataAndTimestamps(barGroups, timestamps);
}

class _MyBarChartState extends State<MyBarChart> {
  @override
  void initState() {
    super.initState();
    final modelA = context.read<ModelA>();
    modelA.startTimer(); // Start the timer to reload data every 15 minutes
    modelA.getHidrometer().then((_) {
      setState(() {}); // Trigger rebuild
    }).catchError((error) {
      print("Error fetching data: $error");
    });
  }

  @override
  void dispose() {
    final modelA = context.read<ModelA>();
    modelA.stopTimer(); // Stop the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelA>(
      builder: (context, modelA, child) {
        return modelA.dadosHidrometer.isNotEmpty
            ? buildChart(modelA)
            : buildLoadingIndicator();
      },
    );
  }

  Widget buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(), // Show loading indicator
    );
  }

  Widget buildChart(ModelA modelA) {
    List<dynamic>? dataHidro =
        modelA.dadosHidrometer[widget.index]['data_counter'] as List<dynamic>?;

    double maxY = 1.0;
    if (dataHidro != null && dataHidro.isNotEmpty) {
      int length = dataHidro.length;
      List<dynamic> lastValues = dataHidro.sublist(dataHidro.length - length);
      maxY = (lastValues
                      .reduce(
                          (value, element) => value > element ? value : element)
                      .toDouble() /
                  100)
              .ceil() *
          100;
    }

    final barChartDataAndTimestamps = generateBarGroups(modelA, widget.index);
    final barGroups = barChartDataAndTimestamps.barGroups;
    final timestamps = barChartDataAndTimestamps.timestamps;

    // Calculate the interval for the x-axis titles
    double interval = (timestamps.length / 5).ceilToDouble();

    return Container(
      height: 520,
      width: 900,
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
      padding: const EdgeInsets.only(left: 10, bottom: 10, right: 40, top: 20),
      child: Column(
        children: [
          const Center(
            child: Text(
              'Litros acumulados',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: BarChart(
              BarChartData(
                minY: 0,
                maxY: maxY,
                barGroups: barGroups,
                borderData: FlBorderData(
                  border: const Border(
                    bottom: BorderSide(
                      color: Colors.transparent,
                    ),
                    left: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                ),
                gridData: const FlGridData(
                  show: true,
                  drawVerticalLine: false,
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                      reservedSize: 64,
                      interval: 15,
                    ),
                  ),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
