import 'package:flutter/material.dart';
import 'package:projeto_2024/Models/models.dart';
import 'package:projeto_2024/charts/linechart.dart';
import 'package:projeto_2024/colors/colors.dart';
import 'package:projeto_2024/components/graphs.dart';
import 'package:projeto_2024/const/consts.dart';
import 'package:projeto_2024/pages/login_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

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
                  onTap: () {
                    ModelA().getHidro1();
                  },
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
                onPressed: logoutFunc,
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
                  itemCount: values.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text("Caixa: ${values[index]['nome']}"),
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
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GraphsComponent(
                  index: currentIndex,
                  dayData: values,
                ),
                MyLineChart()
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GraphsComponent(
                  index: currentIndex,
                  dayData: values,
                ),
                GraphsComponent(
                  index: currentIndex,
                  dayData: values,
                ),
              ],
            ),
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
