import 'dart:async';
import 'package:flutter/material.dart';
import 'package:projeto_2024/Models/models.dart';
import 'package:projeto_2024/charts/linechart.dart';
import 'package:projeto_2024/colors/colors.dart';
import 'package:projeto_2024/components/barchart.dart';
import 'package:projeto_2024/components/clock_widget.dart';
import 'package:projeto_2024/pages/login_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var tempoReload = 15;
  Timer? _timer;
  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    modelA.getWaterTank().then((_) {
      setState(() {
        _isLoading = false; // Set loading state to false when data is loaded
      });
    }).catchError((error) {
      print("Error fetching data: $error");
      setState(() {
        _isLoading = false; // Set loading state to false on error as well
      });
    });
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
    _timer = Timer.periodic(Duration(minutes: tempoReload), (timer) {
      // Call the function to rebuild all children
      rebuildAllChildren();
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
        builder: (context) => const Material(child: MainPage()),
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
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(), // Show a loading indicator
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
                    Text(
                      "Caixa: ${1 + currentIndex}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MouseRegion(
                          cursor: MaterialStateMouseCursor.clickable,
                          onEnter: (event) => setState(() {
                            corBotao = const Color.fromARGB(76, 158, 158, 158);
                          }),
                          onExit: (event) => setState(() {
                            corBotao = Colors.transparent;
                          }),
                          child: GestureDetector(
                            onTap: () {
                              print(modelA.dadosWaterTank[0]['nome'] as String);
                            },
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
                    Expanded(
                      child: ListView.builder(
                        itemCount: modelA.dadosWaterTank.length,
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
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          MyLineChart(index: currentIndex),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          MyBarChart(index: currentIndex),
                        ],
                      ),
                    ],
                  ),
                  Center(
                      child: ClockWidget(
                    tempoReload: tempoReload,
                  )),
                ],
              ),
            ),
          );
  }

  void logoutFunc() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Material(child: LoginPage()),
      ),
    );
  }

  void searchBarFunc() {}
}
