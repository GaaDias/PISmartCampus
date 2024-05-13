import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:projeto_2024/Models/models.dart';
import 'package:projeto_2024/components/bargraphs.dart';
import 'package:projeto_2024/const/consts.dart';

class GraphsComponent extends StatefulWidget {
  final int index;
  final List dayData;
  const GraphsComponent({
    super.key,
    required this.index,
    required this.dayData,
  });

  @override
  State<GraphsComponent> createState() => _GraphsComponentState();
}

class _GraphsComponentState extends State<GraphsComponent> {
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
    BarData myBarData = BarData(
      segAmount: modelA.dados.isNotEmpty
          ? modelA.dados[0]['data_counter'][0].toDouble()
          : 0.0,
      terAmount: modelA.dados.isNotEmpty
          ? modelA.dados[0]['data_counter'][1].toDouble()
          : 0.0,
      quaAmount: modelA.dados.isNotEmpty
          ? modelA.dados[0]['data_counter'][2].toDouble()
          : 0.0,
      quiAmount: modelA.dados.isNotEmpty
          ? modelA.dados[0]['data_counter'][3].toDouble()
          : 0.0,
    );
    myBarData.initializeBarData();

    return Column(
      children: [
        Text(modelA.dados.isNotEmpty
            ? modelA.dados[0]['nome']
            : 'No data available'),
        Container(
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
          child: BarChart(
            BarChartData(
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: bottomTitles,
                        reservedSize: 32)),
                show: true,
              ),
              maxY: 1500,
              minY: 0,
              barGroups: myBarData.barData
                  .map(
                    (data) => BarChartGroupData(x: data.x, barRods: [
                      BarChartRodData(
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: 50,
                            color: const Color.fromARGB(21, 3, 168, 244),
                          ),
                          toY: data.y,
                          width: 40,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          )),
                    ]),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    Widget text;

    const style = TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18);
    switch (value.toInt()) {
      case 1:
        text = const Text(
          "Ter",
          style: style,
        );
        break;
      case 2:
        text = const Text(
          "Qua",
          style: style,
        );
        break;
      case 3:
        text = const Text(
          "Qui",
          style: style,
        );
        break;
      case 4:
        text = const Text(
          "Sex",
          style: style,
        );
        break;
      case 5:
        text = const Text(
          "Sab",
          style: style,
        );
        break;
      case 6:
        text = const Text(
          "Dom",
          style: style,
        );
        break;
      default:
        text = const Text(
          "Seg",
          style: style,
        );
    }
    return SideTitleWidget(axisSide: meta.axisSide, child: text);
  }
}
