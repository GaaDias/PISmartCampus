import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projeto_2024/Models/models.dart';
import 'package:projeto_2024/charts/velocimeterpainter.dart';
import 'package:projeto_2024/colors/colors.dart';
import 'package:projeto_2024/components/top_nav.dart';
import 'package:projeto_2024/pages/all_charts_page.dart';

class ArtesianWellPage extends StatefulWidget {
  const ArtesianWellPage({super.key});

  @override
  State<ArtesianWellPage> createState() => _ArtesianWellPageState();
}

class _ArtesianWellPageState extends State<ArtesianWellPage> {
  final int tempoReload = 15;
  Timer? _timer;
  bool _isLoading = true;
  int elapsedSeconds = 0;
  Color corBotao = Colors.transparent;

  @override
  void initState() {
    super.initState();
    fetchData();
    _startTimer();
  }

  Future<void> fetchData() async {
    try {
      await modelA.getArtesianWell();
    } catch (error) {
      print("Error fetching data: $error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        elapsedSeconds++;
        if (elapsedSeconds >= tempoReload * 60) {
          elapsedSeconds = 0;
          fetchData(); // Refresh data instead of rebuilding the entire page
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : DefaultTabController(
            animationDuration: Duration.zero,
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: azulPadrao,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Artesian Well",
                      style: TextStyle(),
                    ),
                    const TopNav(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MouseRegion(
                          cursor: MaterialStateMouseCursor.clickable,
                          onEnter: (_) => setState(() {
                            corBotao = const Color.fromARGB(76, 158, 158, 158);
                          }),
                          onExit: (_) => setState(() {
                            corBotao = Colors.transparent;
                          }),
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: corBotao,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text("Perfil"),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.logout_outlined),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              drawer: Drawer(
                child: Column(
                  children: [
                    SizedBox(
                      height: 110,
                      child: DrawerHeader(
                        decoration: BoxDecoration(
                          color: azulPadrao,
                        ),
                        child: Center(
                          child: Image.asset('assets/images/LogoApp.png'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(nome(index)),
                            onTap: () {},
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              body: Center(
                child: Velocimeter(
                    speed: getLastDataPressure0(modelA), maxSpeed: 1000),
              ),
            ),
          );
  }

  String nome(int index) {
    switch (index) {
      case 0:
        return "Entrada";
      case 1:
        return "Saida";
      default:
        return "Erro";
    }
  }

  double getLastDataPressure0(ModelA modelA) {
    if (modelA.dadosArtesianWell.isNotEmpty &&
        modelA.dadosArtesianWell[0]['data_pressure_0'] != null &&
        (modelA.dadosArtesianWell[0]['data_pressure_0'] as List).isNotEmpty) {
      List<dynamic> dataCounter =
          modelA.dadosArtesianWell[0]['data_pressure_0'] as List<dynamic>;
      return (dataCounter.last as num).toDouble();
    } else {
      return 0.0; // Return a default value if no data is available
    }
  }
}

class Velocimeter extends StatelessWidget {
  final double speed;
  final double maxSpeed;

  const Velocimeter({required this.speed, required this.maxSpeed});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(400, 400),
      painter: VelocimeterPainter(speed: speed, maxSpeed: maxSpeed),
    );
  }
}
