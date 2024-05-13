import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:projeto_2024/Models/models.dart';

class MyLineChart extends StatefulWidget {
  MyLineChart({super.key});

  @override
  State<MyLineChart> createState() => _MyLineChartState();
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
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(10),
      child: LineChart(
        LineChartData(
          minX: 0,
          minY: 0,
          maxX: 15,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(
                    0,
                    modelA.dados.isNotEmpty
                        ? modelA.dados[0]['data_counter'][0].toDouble()
                        : 0.0),
                FlSpot(
                    1,
                    modelA.dados.isNotEmpty
                        ? modelA.dados[0]['data_counter'][1].toDouble()
                        : 0.0),
                FlSpot(
                    2,
                    modelA.dados.isNotEmpty
                        ? modelA.dados[0]['data_counter'][2].toDouble()
                        : 0.0),
                FlSpot(
                    3,
                    modelA.dados.isNotEmpty
                        ? modelA.dados[0]['data_counter'][3].toDouble()
                        : 0.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
