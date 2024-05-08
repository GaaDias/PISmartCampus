import 'package:flutter/material.dart';
import 'package:projeto_2024/pages/login_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  final List<Widget> _tabs = [
    const LoginPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      animationDuration: Duration.zero,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Nome",
                style: TextStyle(),
              ),
            ],
          ),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: 'Home'),
              Tab(text: 'Tab2'),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(214, 230, 226, 100),
                ),
                child: Center(
                  child: Text(
                    'Reservatorios disponiveis',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ListTile(
                title: const Text('Item 1'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Item 2'),
                onTap: () {},
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            Text("data"),
            Text("Pag2"),
          ],
        ),
      ),
    );
  }
}
