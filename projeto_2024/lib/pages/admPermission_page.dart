import 'package:flutter/material.dart';
import 'package:projeto_2024/colors/colors.dart';
import 'package:projeto_2024/pages/newWatertank_page.dart';
import 'package:projeto_2024/pages/register_page.dart';

class AdmPermissionPage extends StatefulWidget {
  const AdmPermissionPage({super.key});

  @override
  _AdmPermissionPageState createState() => _AdmPermissionPageState();
}

class _AdmPermissionPageState extends State<AdmPermissionPage> {
  String currentPage = 'Permissão de ADM';

  void logoutFunc(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AdmPermissionPage()),
    );
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
              return const AdmPermissionPage();
            } else {
              return const RegisterPage();
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
    final formKey = GlobalKey<FormState>();
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 1000),
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
                const SizedBox(width: 30),
                const Text('Perfil', style: TextStyle(fontSize: 20)),
                const Spacer(),
                SizedBox(
                  width: screenSize.width / 50,
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
            ListTile(
              title: const Text('Adicionar colaborador', style: TextStyle(color: Colors.black)),
              titleAlignment: ListTileTitleAlignment.center,
              selected: currentPage == 'Adicionar colaborador',
              selectedTileColor: Colors.grey[300],
              onTap: () {
                _navigateToPage('Adicionar colaborador');
              },
            ),
            ListTile(
              title: const Text('Permissão de ADM', style: TextStyle(color: Colors.black)),
              titleAlignment: ListTileTitleAlignment.center,
              selected: currentPage == 'Permissão de ADM',
              selectedTileColor: Colors.grey[350],
              onTap: () {
                _navigateToPage('Permissão de ADM');
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
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.3,
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
                          'Conceder permissão de administrador a outro colaborador:',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
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
                          labelText: 'E-mail do colaborador',
                          labelStyle: TextStyle(color: Colors.black),
                          floatingLabelStyle: TextStyle(color: Colors.black),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o e-mail do colaborador';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Por favor, insira um e-mail válido';
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
                            if (formKey.currentState?.validate() ?? false) {
                            }
                          },
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
  
  backFunc(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NewTankPage()),
    );
  }
}