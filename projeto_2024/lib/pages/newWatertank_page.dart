import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_2024/Models/models.dart';
import 'package:projeto_2024/colors/colors.dart';
import 'package:projeto_2024/components/top_nav.dart';
import 'package:projeto_2024/pages/adm_permission_page.dart';
import 'package:projeto_2024/pages/login_page.dart';
import 'package:projeto_2024/pages/maintenance_page.dart';
import 'package:projeto_2024/pages/register_page.dart';
import 'package:provider/provider.dart';

class NewTankPage extends StatefulWidget {
  const NewTankPage({super.key, required this.email});
  final String? email;

  @override
  State<NewTankPage> createState() => _NewTankPageState();
}

class _NewTankPageState extends State<NewTankPage> {
  String currentPage = 'Adicionar novo reservatório de água';
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

  void _navigateToPage(String page) {
    if (page != currentPage) {
      setState(() {
        currentPage = page;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            if (page == 'Permissão de ADM') {
              return AdmPermissionPage(
                email: widget.email,
              );
            } else if (page == 'Adicionar colaborador') {
              return RegisterPage(
                email: widget.email,
              );
            } else if (page == 'Adicionar novo reservatório de água') {
              return NewTankPage(
                email: widget.email,
              );
            } else if (page == 'Reserva de horário') {
              return MaintenancePage(
                email: widget.email,
              );
            } else {
              return AdmPermissionPage(
                email: widget.email,
              );
            }
          },
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color corBotao = Colors.transparent;

    final formKey = GlobalKey<FormState>();
    var screenSize = MediaQuery.of(context).size;
    var isMobile = screenSize.width < 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: azulPadrao,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const TopNav(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(
                          email: widget.email,
                        ),
                      ),
                    );
                  },
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
                decoration: BoxDecoration(color: azulPadrao),
                child: Center(child: Image.asset('assets/images/LogoApp.png')),
              ),
            ),
            ListTile(
              title: const Text('Adicionar colaborador',
                  style: TextStyle(color: Colors.black)),
              titleAlignment: ListTileTitleAlignment.center,
              selected: currentPage == 'Adicionar colaborador',
              selectedTileColor: Colors.grey[350],
              onTap: () {
                _navigateToPage('Adicionar colaborador');
              },
            ),
            ListTile(
              title: const Text('Permissão de ADM',
                  style: TextStyle(color: Colors.black)),
              titleAlignment: ListTileTitleAlignment.center,
              selected: currentPage == 'Permissão de ADM',
              selectedTileColor: Colors.grey[350],
              onTap: () {
                _navigateToPage('Permissão de ADM');
              },
            ),
            ListTile(
              title: const Text('Adicionar novo reservatório de água',
                  style: TextStyle(color: Colors.black)),
              titleAlignment: ListTileTitleAlignment.center,
              selected: currentPage == 'Adicionar novo reservatório de água',
              selectedTileColor: Colors.grey[350],
              onTap: () {
                _navigateToPage('Adicionar novo reservatório de água');
              },
            ),
            ListTile(
              title: const Text('Reservar horário para manutenção',
                  style: TextStyle(color: Colors.black)),
              titleAlignment: ListTileTitleAlignment.center,
              selected: currentPage == 'Reserva de horário',
              selectedTileColor: Colors.grey[350],
              onTap: () {
                _navigateToPage('Reserva de horário');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: SizedBox(
            width: isMobile ? screenSize.width * 0.9 : screenSize.width * 0.5,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Center(
                        child: Text(
                          'Adicionar reservatórios:',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelText: 'Nome do reservatório',
                          labelStyle: TextStyle(color: Colors.black),
                          floatingLabelStyle: TextStyle(color: Colors.black),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o nome do reservatório';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      'Parâmetros dos sensores do nível de água:',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              labelText: 'Nível Mínimo',
                              labelStyle: TextStyle(color: Colors.black),
                              floatingLabelStyle:
                                  TextStyle(color: Colors.black),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  double.tryParse(value) == null ||
                                  double.parse(value) <= 0) {
                                return 'Por favor, insira um valor válido';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              labelText: 'Nível Máximo',
                              labelStyle: TextStyle(color: Colors.black),
                              floatingLabelStyle:
                                  TextStyle(color: Colors.black),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  double.tryParse(value) == null) {
                                return 'Por favor, insira um valor válido';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelText: 'Localização do reservatório',
                          labelStyle: TextStyle(color: Colors.black),
                          floatingLabelStyle: TextStyle(color: Colors.black),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira a localização do reservatório';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: SizedBox(
                        width: 180,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) {}
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered)) {
                                  return Colors.grey[500]!;
                                }
                                return Colors.grey[300]!;
                              },
                            ),
                          ),
                          child: const Text(
                            'Adicionar',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, String title, String currentPage, bool isMobile) {
    return InkWell(
      onTap: () {
        // Navigate to the corresponding page
      },
      child: Text(
        title,
        style: TextStyle(
          color: currentPage == title ? Colors.black87 : Colors.black,
          fontSize: isMobile ? 14 : 20,
          fontWeight:
              currentPage == title ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
