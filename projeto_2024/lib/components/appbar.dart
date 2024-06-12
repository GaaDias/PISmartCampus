import 'package:flutter/material.dart';
import 'package:projeto_2024/colors/colors.dart';
import 'package:projeto_2024/components/top_nav.dart';
import 'package:projeto_2024/pages/tela_inicial.dart';

class MyAppBar extends StatefulWidget {
  final String texto;
  const MyAppBar({super.key, required this.myBody, required this.texto});
  final Widget myBody;
  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  var corBotao;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: azulPadrao,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.texto,
                style: const TextStyle(),
              ),
              const TopNav(),
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
        body: widget.myBody);
  }

  void logoutFunc() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Material(child: LoginPage()),
      ),
    );
  }
}
