import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projeto_2024/colors/colors.dart';
import 'package:projeto_2024/pages/newWatertank_page.dart';
import 'package:projeto_2024/pages/register_page.dart';
import 'package:http/http.dart' as http;

class AdmPermissionPage extends StatefulWidget {
  const AdmPermissionPage({super.key});

  @override
  _AdmPermissionPageState createState() => _AdmPermissionPageState();
}

class _AdmPermissionPageState extends State<AdmPermissionPage> {
  String currentPage = 'Permissão de ADM';
  final formKey = GlobalKey<FormState>(); 
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = true;
  bool isAdmin = false;

  final String permissaoAdmUrl = 'http://127.0.0.1:8000/altera_adm/';
  final String checkAdminUrl = 'http://127.0.0.1:8000/verifica_adm/';

  @override
  void initState() {
    super.initState();
    checkAdminPermission(); // Check permission on page load
  }

  @override
  void dispose() {
    _emailController.dispose(); 
    super.dispose();
  }

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

  Future<void> checkAdminPermission() async {
    try {
      // Assuming you have a way to get the logged-in user's email
      String userEmail = _emailController.text.trim(); 

      final response = await http.post(
        Uri.parse(checkAdminUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': userEmail}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          isAdmin = responseData['is_admin']; // Update the admin status
        });
      } else if (response.statusCode == 403) {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text("403 FORBIDDEN"),
              content: const Text("Você não possui autorização para acessar essa página"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text("Erro"),
              content: const Text("Usuário não cadastrado"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      // Handle network errors
    } finally {
      setState(() {
        isLoading = false; // Finished loading, hide loading indicator
      });
    }
  }

  Future<void> permissaoADM(BuildContext context) async {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Erro"),
          content: const Text("Por favor, insira um e-mail válido"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return; 
    }

    try {
      final response = await http.post(
        Uri.parse(permissaoAdmUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text("Sucesso"),
              content: const Text("Permissão concedida!"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      } else if (response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text("Aviso"),
              content: const Text("Usuário já possui permissão!"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }else if (response.statusCode == 404) {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text("Aviso"),
              content: const Text("Usuário não está cadastrado!"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
      else {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text("Erro"),
              content: const Text("Falha ao conceder permissão"), // More informative error message
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text("Erro"),
            content: const Text("Ocorreu um erro ao enviar o e-mail."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    var screenSize = MediaQuery.of(context).size;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator()); // Show loading indicator
    }

    if (!isAdmin) {
      // Redirect if not admin
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NewTankPage()),
        );
      });
      return Container(); // Return an empty container while redirecting
    }

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
                        controller: _emailController,
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
                      ),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: SizedBox(
                        width: 180,
                        child: ElevatedButton(
                          onPressed: () => permissaoADM(context),
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