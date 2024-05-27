import 'package:flutter/material.dart';
import 'package:projeto_2024/colors/colors.dart';
import 'package:projeto_2024/pages/newWatertank_page.dart';

class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key});

  void logoutFunc(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NewTankPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    var screenSize = MediaQuery.of(context).size;
    var isMobile = screenSize.width < 600;

    String currentPage = 'Nível de água'; 

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 60),
        child: Container(
          color: azulPadrao,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                Expanded(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: isMobile ? 8.0 : screenSize.width / 30,
                    runSpacing: isMobile ? 8.0 : 0.0,
                    children: [
                      _buildMenuItem(context, 'Nível de água', currentPage, isMobile),
                      const Text('|', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      _buildMenuItem(context, 'Vazão de água', currentPage, isMobile),
                      const Text('|', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      _buildMenuItem(context, 'Pressão do poço', currentPage, isMobile),
                      const Text('|', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      _buildMenuItem(context, 'Bomba do poço', currentPage, isMobile),
                    ],
                  ),
                ),
                SizedBox(
                  width: screenSize.width / 50,
                ),
                InkWell(
                        onTap: () {},
                        child: const Text(
                          'Perfil',
                          style: TextStyle(color: Colors.black, fontSize: 19),
                        ),
                      ),
                IconButton(
                  onPressed: () => logoutFunc(context),
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(
              height: 110,
              child: DrawerHeader(
                decoration: BoxDecoration(color: azulPadrao),
                child: Center(child: Image.asset('assets/images/LogoApp.png')),
              ),
            ),
            SizedBox(
              height: 50,
              child: ListTile(
                title: const Text("Manutenção"),
                titleAlignment: ListTileTitleAlignment.center,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Reserva de horário pra manutenção',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 23),
                const Text(
                  'Horários disponíveis:',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 15),
                Center(
                  child: Container(
                    width: isMobile ? screenSize.width * 0.9 : screenSize.width * 0.5,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered)) {
                                  return Colors.grey[500]!;
                                }
                                return Colors.grey[300]!;
                              },
                            ),
                          ),
                          child: const Text('00h às 02h', style: TextStyle(color: Colors.black)),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered)) {
                                  return Colors.grey[500]!;
                                }
                                return Colors.grey[300]!;
                              },
                            ),
                          ),
                          child: const Text('02h às 04h', style: TextStyle(color: Colors.black)),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered)) {
                                  return Colors.grey[500]!;
                                }
                                return Colors.grey[300]!;
                              },
                            ),
                          ),
                          child: const Text('04h às 06h', style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Datas disponíveis:',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 15),
                Center(
                  child: Container(
                    width: isMobile ? screenSize.width * 0.9 : screenSize.width * 0.5,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered)) {
                                  return Colors.grey[500]!;
                                }
                                return Colors.grey[300]!;
                              },
                            ),
                          ),
                          child: const Text('01/06', style: TextStyle(color: Colors.black)),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered)) {
                                  return Colors.grey[500]!;
                                }
                                return Colors.grey[300]!;
                              },
                            ),
                          ),
                          child: const Text('02/06', style: TextStyle(color: Colors.black)),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered)) {
                                  return Colors.grey[500]!;
                                }
                                return Colors.grey[300]!;
                              },
                            ),
                          ),
                          child: const Text('03/06', style: TextStyle(color: Colors.black)),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered)) {
                                  return Colors.grey[500]!;
                                }
                                return Colors.grey[300]!;
                              },
                            ),
                          ),
                          child: const Text('04/06', style: TextStyle(color: Colors.black)),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered)) {
                                  return Colors.grey[500]!;
                                }
                                return Colors.grey[300]!;
                              },
                            ),
                          ),
                          child: const Text('05/06', style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      backgroundColor: Colors.grey[300],
                      textStyle: const TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    child: const Text(
                      'Reservar',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, String currentPage, bool isMobile) {
    return InkWell(
      onTap: () {
        // Navigate to the corresponding page
      },
      child: Text(
        title,
        style: TextStyle(
          color: currentPage == title ? Colors.black87 : Colors.black,
          fontSize: isMobile ? 14 : 20,
          fontWeight: currentPage == title ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}