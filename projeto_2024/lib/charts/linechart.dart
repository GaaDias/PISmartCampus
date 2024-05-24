import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/rendering.dart';
import 'package:projeto_2024/Models/models.dart';
import 'package:projeto_2024/colors/colors.dart';

class MyLineChart extends StatefulWidget {
  final int index;
  const MyLineChart({
    super.key,
    required this.index,
  });

  @override
  State<MyLineChart> createState() => _MyLineChartState();
}

class FlSpotAndTimestamps {
  List<FlSpot> spots;
  List<String> timestamps;

  FlSpotAndTimestamps(this.spots, this.timestamps);
}

FlSpotAndTimestamps generateFlSpots(ModelA modelA, int index) {
  List<FlSpot> spots = [];
  List<String> timestamps = [];

  if (modelA.dadosWaterTank.isNotEmpty) {
    List<dynamic>? dataCounter =
        modelA.dadosWaterTank[index]['data_distance'] as List<dynamic>?;
    List<dynamic>? timestampsData =
        modelA.dadosWaterTank[index]['timestamp'] as List<dynamic>?;

    if (dataCounter != null && timestampsData != null) {
      int length = dataCounter.length;
      int start = length > 15 ? length - 15 : 0;

      for (int i = start; i < length; i++) {
        spots.add(FlSpot(i - start.toDouble(), dataCounter[i].toDouble()));
        String timestamp = timestampsData[i].toString();
        timestamps.add(
            timestamp.substring(timestamp.length - 8)); // get last 8 characters
      }
    } else {
      for (int i = 0; i < 15; i++) {
        spots.add(FlSpot(i.toDouble(), 0.0));
        timestamps.add('');
      }
    }
  } else {
    for (int i = 0; i < 15; i++) {
      spots.add(FlSpot(i.toDouble(), 0.0));
      timestamps.add('');
    }
  }

  return FlSpotAndTimestamps(spots, timestamps);
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

    final flSpotAndTimestamps = generateFlSpots(modelA, widget.index);
    final spots = flSpotAndTimestamps.spots;
    final timestamps = flSpotAndTimestamps.timestamps;

    return Container(
      height: 420,
      width: 700,
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
                    color: azulPadrao,
                    spots: spots,
                    isCurved: false,
                    belowBarData: BarAreaData(
                      show: true,
                      color: azulPadraoSemiInv,
                    ),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        if (spot.y < 1000) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.red,
                            strokeWidth: 0,
                          );
                        } else {
                          return FlDotCirclePainter(
                            radius: 1,
                            color: azulPadrao,
                            strokeWidth: 0,
                          );
                        }
                      },
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
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true, interval: 1000, reservedSize: 32),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 64,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < timestamps.length) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            angle: 5.7,
                            child: Text(
                              timestamps[value.toInt()],
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          );
                        } else {
                          return const Text('');
                        }
                      },
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
