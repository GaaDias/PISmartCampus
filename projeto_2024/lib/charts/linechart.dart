import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:projeto_2024/Models/models.dart';

class MyLineChart extends StatefulWidget {
  final int index;
  const MyLineChart({
    super.key,
    required this.index,
  });

  @override
  State<MyLineChart> createState() => _MyLineChartState();
}

List<FlSpot> generateFlSpots(ModelA modelA, int index) {
  List<FlSpot> spots = [];

  if (modelA.dadosWaterTank.isNotEmpty) {
    List<dynamic>? dataCounter =
        modelA.dadosWaterTank[index]['data_distance'] as List<dynamic>?;

    if (dataCounter != null) {
      for (int i = 0; i < dataCounter.length && i < 15; i++) {
        spots.add(FlSpot(i.toDouble(), dataCounter[i].toDouble()));
      }
    } else {
      for (int i = 0; i < 15; i++) {
        spots.add(FlSpot(i.toDouble(), 0.0));
      }
    }
  } else {
    for (int i = 0; i < 15; i++) {
      spots.add(FlSpot(i.toDouble(), 0.0));
    }
  }

  return spots;
}

class _MyLineChartState extends State<MyLineChart> {
  ModelA modelA = ModelA();

  @override
  void initState() {
    super.initState();
    modelA.getWaterTank().then((_) {
      setState(() {}); // Trigger rebuild
    }).catchError((error) {
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
    return const Center(
      child: CircularProgressIndicator(), // Show loading indicator
    );
  }

  Widget buildChart() {
    List<dynamic>? dataCounter =
        modelA.dadosWaterTank[widget.index]['data_distance'] as List<dynamic>?;

    double maxY = 1.0;
    if (dataCounter != null && dataCounter.isNotEmpty) {
      int length = dataCounter.length > 15 ? 15 : dataCounter.length;
      maxY = (dataCounter
                      .sublist(0, length)
                      .reduce(
                          (value, element) => value > element ? value : element)
                      .toDouble() /
                  1000)
              .ceil() *
          1000;
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
      padding: const EdgeInsets.only(left: 10, bottom: 10, right: 40, top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              modelA.dadosWaterTank[widget.index]['nome'] as String,
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
            child: LineChart(
              LineChartData(
                minX: 0,
                minY: 0,
                maxX: 15,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: generateFlSpots(modelA, widget.index),
                    isCurved: false,
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color.fromARGB(51, 83, 162, 241),
                    ),
                    dotData: const FlDotData(
                      show: false,
                    ),
                  ),
                ],
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
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true, interval: 1000, reservedSize: 32),
                  ),
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
