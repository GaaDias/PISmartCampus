import 'package:flutter/material.dart';
import 'package:projeto_2024/pages/main_page.dart';

class Forms extends StatefulWidget {
  const Forms({super.key});

  @override
  State<Forms> createState() => _FormsState();
}

var testColor = Colors.white;

class _FormsState extends State<Forms> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            "Seja Bem Vindo",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 32,
              shadows: <Shadow>[
                Shadow(
                  color: Color.fromARGB(135, 0, 0, 0),
                  blurRadius: 2,
                  offset: Offset(2, 4),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: entrar,
            child: MouseRegion(
              cursor: MaterialStateMouseCursor.clickable,
              onEnter: (event) {
                setState(() {
                  testColor = const Color.fromARGB(255, 218, 218, 218);
                });
              },
              onExit: (event) {
                setState(() {
                  testColor = Colors.white;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: testColor,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(99, 0, 0, 0),
                        spreadRadius: 5,
                        blurRadius: 4,
                        offset: Offset(0, 5),
                      ),
                    ]),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Image.asset(
                  'assets/images/Microsoft_logo_(2012).png',
                  scale: 3.5,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  void entrar() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MainPage(),
      ),
    );
  }
}
