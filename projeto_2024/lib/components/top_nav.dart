import 'package:flutter/material.dart';
import 'package:projeto_2024/components/toppages.dart';
import 'package:projeto_2024/pages/all_charts_page.dart';
import 'package:projeto_2024/pages/water_level_page.dart';

class TopNav extends StatelessWidget {
  const TopNav({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TopPages(
            texto: 'Nivel de agua',
            rota: WaterLevelPage(),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("|"),
          ),
          TopPages(
            texto: 'Vazão de agua',
            rota: WaterLevelPage(),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("|"),
          ),
          TopPages(
            texto: 'Pressão poço',
            rota: AllChartsPage(),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("|"),
          ),
          TopPages(
            texto: 'Bomba poço',
            rota: AllChartsPage(),
          ),
        ],
      ),
    );
  }
}
