import 'package:flutter/material.dart';
import 'package:projeto_2024/colors/colors.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  void logoutFunc(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AddPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    var screenSize = MediaQuery.of(context).size;
    var isMobile = screenSize.width < 600;

    // Variable to track the current page
    String currentPage = 'Nível de água'; // Change this based on the current page

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
                              floatingLabelStyle: TextStyle(color: Colors.black),
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
                              floatingLabelStyle: TextStyle(color: Colors.black),
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
                            if (formKey.currentState?.validate() ?? false) {
                            }
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

  Widget _buildMenuItem(BuildContext context, String title, String currentPage, bool isMobile) {
    return InkWell(
      onTap: () {
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
