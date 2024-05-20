import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:projeto_2024/Models/models.dart';

class MyBarChart extends StatefulWidget {
  final int index;
  const MyBarChart({Key? key, required this.index}) : super(key: key);

  @override
  State<MyBarChart> createState() => _MyBarChartState();
}

List<BarChartGroupData> generateBarGroups(ModelA modelA, int index) {
  List<BarChartGroupData> barGroups = [];

  if (modelA.dadosHidrometer.isNotEmpty) {
    List<dynamic>? dataHidro =
        modelA.dadosHidrometer[index]['data_counter'] as List<dynamic>?;

    if (dataHidro != null) {
      for (int i = 0; i < dataHidro.length && i < 15; i++) {
        barGroups.add(
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: dataHidro[i].toDouble(),
                color: Colors.blue,
                width: 15,
              )
            ],
          ),
        );
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
                width: 15,
              )
            ],
          ),
        );
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
              width: 15,
            )
          ],
        ),
      );
    }
  }

  return barGroups;
}

class _MyBarChartState extends State<MyBarChart> {
  ModelA modelA = ModelA();

  void reloadData() {
    // Call setState to trigger a rebuild
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    modelA.getHidrometer().then((_) {
      setState(() {}); // Trigger rebuild
    }).catchError((error) {
      print("Error fetching data: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return modelA.dadosHidrometer.isNotEmpty
        ? buildChart()
        : buildLoadingIndicator();
  }

  Widget buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(), // Show loading indicator
    );
  }

  Widget buildChart() {
    List<dynamic>? dataHidro =
        modelA.dadosHidrometer[widget.index]['data_counter'] as List<dynamic>?;

    double maxY = 1.0;
    if (dataHidro != null && dataHidro.isNotEmpty) {
      int length = dataHidro.length > 15 ? 15 : dataHidro.length;
      maxY = (dataHidro
                      .sublist(0, length)
                      .reduce(
                          (value, element) => value > element ? value : element)
                      .toDouble() /
                  100)
              .ceil() *
          100;
    }

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
      child: Column(
        children: [
          Center(
            child: Text(
              modelA.dadosHidrometer[widget.index]['nome'] as String,
              textAlign: TextAlign.center,
              style: const TextStyle(
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
                barGroups: generateBarGroups(modelA, widget.index),
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
                gridData: const FlGridData(show: true, drawVerticalLine: false),
                titlesData: const FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true, interval: 5, reservedSize: 32),
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
