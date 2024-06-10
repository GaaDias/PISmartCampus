import 'dart:async';
import 'package:at_viz/at_gauges/at_gauges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_2024/Models/models.dart';
import 'package:projeto_2024/colors/colors.dart';
import 'package:projeto_2024/components/top_nav.dart';
import 'package:projeto_2024/pages/all_charts_page.dart';
import 'package:projeto_2024/pages/login_page.dart';

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
                          onPressed: logoutFunc,
                          icon: const Icon(Icons.logout_outlined),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              body: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //Entrada
                    Container(
                      height: 500,
                      width: 500,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.only(top: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Pressão de entrada",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ScaleRadialGauge(
                            needleColor: azulPadrao,
                            pointerColor: Colors.green,
                            size: 400,
                            actualValue: getLastDataPressure0(modelA),
                            maxValue: 1000,
                            unit: TextSpan(text: "N/m²"),
                          ),
                        ],
                      ),
                    ),
                    //Saida
                    Container(
                      height: 500,
                      width: 500,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.only(top: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Pressão de saída",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ScaleRadialGauge(
                            needleColor: azulPadrao,
                            pointerColor: Colors.red,
                            size: 400,
                            actualValue: getLastDataPressure1(modelA),
                            maxValue: 5000,
                            unit: TextSpan(text: "N/m²"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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

  double getLastDataPressure1(ModelA modelA) {
    if (modelA.dadosArtesianWell.isNotEmpty &&
        modelA.dadosArtesianWell[0]['data_pressure_1'] != null &&
        (modelA.dadosArtesianWell[0]['data_pressure_1'] as List).isNotEmpty) {
      List<dynamic> dataCounter =
          modelA.dadosArtesianWell[0]['data_pressure_1'] as List<dynamic>;
      return (dataCounter.last as num).toDouble();
    } else {
      return 0.0; // Return a default value if no data is available
    }
  }

  Future<void> logoutFunc() async {
    try {
      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // Navigate back to login page
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Material(child: LoginPage()),
        ),
      );
    } catch (e) {
      print("Error during sign-out: $e");
      // Handle error, e.g., show a dialog with the error message
    }
  }
}
