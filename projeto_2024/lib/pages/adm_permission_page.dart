import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_2024/colors/colors.dart';
import 'package:projeto_2024/pages/error_page.dart';
import 'package:projeto_2024/pages/login_page.dart';
import 'package:projeto_2024/pages/newWatertank_page.dart';
import 'package:projeto_2024/pages/register_page.dart';
import 'package:http/http.dart' as http;

class AdmPermissionPage extends StatefulWidget {
  const AdmPermissionPage({super.key, required this.email});
  final String? email;

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
    print(widget.email);
    try {
      String userEmail = widget.email?.trim() ?? '';
      final response = await http.post(
        Uri.parse(checkAdminUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': userEmail}),
      );
      final responseData = json.decode(response.body);

      print(isAdmin);
      print(responseData['is_admin']);
      if (response.statusCode == 200) {
        setState(() {
          isAdmin = true; // Update the admin status
        });
      } else if (response.statusCode == 403) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const ErroPage(
                    mensagemErro: "403 FORBIDDEN",
                    codigoErro:
                        "Você não possui autorização para acessar essa página",
                  )),
        );
      } else {
        popUps(
          context,
          "Erro",
          "Usuário não cadastrado",
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NewTankPage()),
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
      popUps(context, "text", 'Line');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(permissaoAdmUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        popUps(
          context,
          "Sucesso",
          "Permissão concedida!",
        );
      } else if (response.statusCode == 201) {
        popUps(
          context,
          "Aviso",
          "Usuário já possui permissão!",
        );
      } else if (response.statusCode == 404) {
        popUps(
          context,
          "Aviso",
          "Usuário não está cadastrado!",
        );
      } else {
        popUps(
          context,
          "Erro",
          "Falha ao conceder permissão",
        );
      }
    } catch (error) {
      popUps(
        context,
        "Erro",
        "Ocorreu um erro ao enviar o e-mail.",
      );
    }
  }

  Future<dynamic> popUps(BuildContext context, String title, String texto) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(texto),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const NewTankPage()),
            ),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    if (isLoading) {
      return const Center(
          child: CircularProgressIndicator()); // Show loading indicator
    }

    if (isAdmin = false) {
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
                  onPressed: () => logoutFunc(),
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
              title: const Text('Adicionar colaborador',
                  style: TextStyle(color: Colors.black)),
              titleAlignment: ListTileTitleAlignment.center,
              selected: currentPage == 'Adicionar colaborador',
              selectedTileColor: Colors.grey[300],
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

  backFunc(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NewTankPage()),
    );
  }
}
