import 'package:flutter/material.dart';
import 'package:projeto_2024/colors/colors.dart';
import 'package:projeto_2024/pages/login_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    LoginPage(),
    Text(
      'Index 1: Business',
    ),
    Text(
      'Index 2: School',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
      Navigator.pop(context);
    });
  }

  var corBotao = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      animationDuration: Duration.zero,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: azulPadrao,
          title: Row(
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: corBotao,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text(
                      "Perfil",
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.logout_outlined),
              )
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
                    child: Image.asset(
                      'assets/images/LogoApp.png',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(index.toString()),
                      onTap: () {
                        _onItemTapped(index);
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
        body: Center(
          child: _widgetOptions[currentIndex],
        ),
      ),
    );
  }
}
