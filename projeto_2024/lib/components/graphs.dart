import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
      segAmount: (values[widget.index]['idade'] as List<int>)[0].toDouble(),
      terAmount: (values[widget.index]['idade'] as List<int>)[1].toDouble(),
      quaAmount: (values[widget.index]['idade'] as List<int>)[2].toDouble(),
      quiAmount: (values[widget.index]['idade'] as List<int>)[3].toDouble(),
      sexAmount: (values[widget.index]['idade'] as List<int>)[4].toDouble(),
      sabAmount: (values[widget.index]['idade'] as List<int>)[5].toDouble(),
      domAmount: (values[widget.index]['idade'] as List<int>)[6].toDouble(),
    );
    myBarData.initializeBarData();

    return Container(
      height: 260,
      width: 600,
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
                    reservedSize: 24)),
            show: true,
          ),
          maxY: 50,
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
