import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:projeto_2024/Models/models.dart';
import 'package:projeto_2024/colors/colors.dart';
import 'package:projeto_2024/charts/barchart.dart';
import 'package:projeto_2024/components/clock_widget.dart';
import 'package:projeto_2024/components/top_nav.dart';
import 'package:projeto_2024/components/toppages.dart';
import 'package:projeto_2024/pages/all_charts_page.dart';
import 'package:projeto_2024/pages/login_page.dart';

class HidrometerPage extends StatefulWidget {
  const HidrometerPage({Key? key});

  @override
  State<HidrometerPage> createState() => _HidrometerPageState();
}

class _HidrometerPageState extends State<HidrometerPage> {
  var tempoReload = 15;
  Timer? _timer;
  bool _isLoading = true; // Track loading state
  int elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    modelA.getHidrometer().then((_) {
      setState(() {
        _isLoading = false; // Set loading state to false when data is loaded
      });
    }).catchError((error) {
      print("Error fetching data: $error");
      setState(() {
        _isLoading = false; // Set loading state to false on error as well
      });
    });
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        elapsedSeconds++;
        if (elapsedSeconds >= tempoReload * 60) {
          elapsedSeconds = 0;
          // Call the function to rebuild all children
          rebuildAllChildren();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void rebuildAllChildren() {
    print("Page Reloaded");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const Material(child: HidrometerPage()),
      ),
    );
  }

  int currentIndex = 0;
  ModelA modelA = ModelA();

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
      Navigator.pop(context);
    });
  }

  var corBotao = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return _isLoading // Check loading state
        ? const Material(
            child: Scaffold(
              body: Center(
                child: CircularProgressIndicator(), // Show a loading indicator
              ),
            ),
          )
        : DefaultTabController(
            animationDuration: Duration.zero,
            length: 2,
            child: Material(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: azulPadrao,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Caixa: ${1 + currentIndex}",
                        style: const TextStyle(),
                      ),
                      TopNav(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MouseRegion(
                            cursor: MaterialStateMouseCursor.clickable,
                            onEnter: (event) => setState(() {
                              corBotao =
                                  const Color.fromARGB(76, 158, 158, 158);
                            }),
                            onExit: (event) => setState(() {
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
                                child: const Text(
                                  "Perfil",
                                ),
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
                      ListTile(
                        title: const Text("Geral"),
                        onTap: () {
                          _goToOnTap();
                        },
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: modelA.dadosHidrometer.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text("Caixa: ${1 + index}"),
                              onTap: () {
                                _onItemTapped(index);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                body: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: MyBarChart(index: currentIndex),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  void _goToOnTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Material(child: AllChartsPage()),
      ),
    );
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