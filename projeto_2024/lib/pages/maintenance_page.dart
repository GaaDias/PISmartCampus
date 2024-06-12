import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_2024/colors/colors.dart';
import 'package:projeto_2024/components/top_nav.dart';
import 'package:projeto_2024/pages/adm_permission_page.dart';
import 'package:projeto_2024/pages/login_page.dart';
import 'package:projeto_2024/pages/newWatertank_page.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:projeto_2024/pages/register_page.dart';

class MaintenancePage extends StatefulWidget {
  final String? email;

  const MaintenancePage({super.key, required this.email});

  @override
  _MaintenancePageState createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {
  String currentPage = 'Reserva de horário';
  final formKey = GlobalKey<FormState>();
  String? selectedTime;
  DateTime? selectedDate;

  List<String> availableTimes = ['00h às 02h', '02h às 04h', '04h às 06h'];
  List<DateTime> availableDates = [
    DateTime.now(),
    DateTime.now().add(const Duration(days: 1)),
    DateTime.now().add(const Duration(days: 2)),
    DateTime.now().add(const Duration(days: 3)),
    DateTime.now().add(const Duration(days: 4)),
  ];

  Future<void> sendReservation(BuildContext context) async {
    if (selectedDate == null || selectedTime == null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Erro"),
          content: const Text("Por favor, selecione uma data e um horário."),
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

    String formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate!);

    const String apiUrl = 'http://127.0.0.1:8000/envia_email/';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'data': formattedDate, 'horario': selectedTime}),
      );

      if (response.statusCode == 200) {
        print('Reservation successful');
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text("Sucesso"),
              content: const Text("Reserva realizada com sucesso!"),
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
        print('Failed to make reservation');
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text("Erro"),
              content: const Text("Falha ao realizar a reserva."),
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
    } catch (e) {
      print('Error: $e');
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text("Erro"),
            content: const Text("Ocorreu um erro ao enviar a reserva."),
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
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
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
                        children: availableTimes.map((time) => ElevatedButton(
                          onPressed: () => setState(() => selectedTime = time),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedTime == time ? azulPadrao : Colors.grey[300],
                            textStyle: const TextStyle(color: Colors.black),
                          ),
                          child: Text(time, 
                          style: const TextStyle(fontSize: 15, color: Colors.black),
                          textAlign: TextAlign.center),
                        )).toList(),
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
                        children: availableDates.map((date) => ElevatedButton(
                          onPressed: () => setState(() => selectedDate = date),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedDate == date ? azulPadrao : Colors.grey[300],
                            textStyle: const TextStyle(color: Colors.black),
                          ),
                          child: Text(DateFormat('dd/MM').format(date), 
                          style: const TextStyle(fontSize: 15, color: Colors.black),
                          textAlign: TextAlign.center),
                        )).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                          onPressed: () => sendReservation(context),
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
                            'Reservar',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                ],
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
