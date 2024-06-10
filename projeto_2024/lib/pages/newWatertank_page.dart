import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_2024/colors/colors.dart';
import 'package:projeto_2024/components/top_nav.dart';
import 'package:projeto_2024/pages/login_page.dart';

class NewTankPage extends StatefulWidget {
  const NewTankPage({super.key});

  @override
  State<NewTankPage> createState() => _NewTankPageState();
}

class _NewTankPageState extends State<NewTankPage> {
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

  @override
  Widget build(BuildContext context) {
    Color corBotao = Colors.transparent;

    final formKey = GlobalKey<FormState>();
    var screenSize = MediaQuery.of(context).size;
    var isMobile = screenSize.width < 600;

    String currentPage = 'Nível de água';

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
                MouseRegion(
                  cursor: MaterialStateMouseCursor.clickable,
                  onEnter: (_) => setState(() {
                    corBotao = const Color.fromARGB(76, 158, 158, 158);
                  }),
                  onExit: (_) => setState(() {
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
                      child: const Text("Perfil"),
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
                decoration: BoxDecoration(color: azulPadrao),
                child: Center(child: Image.asset('assets/images/LogoApp.png')),
              ),
            ),
            SizedBox(
              height: 50,
              child: ListTile(
                title: const Text("Adicionar reservatórios"),
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
