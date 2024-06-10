import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projeto_2024/colors/colors.dart';
import 'package:projeto_2024/pages/newWatertank_page.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MaintenancePage extends StatefulWidget {
  const MaintenancePage({super.key});

  @override
  _MaintenancePageState createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {
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

  void logoutFunc(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NewTankPage()),
    );
  }

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

  @override
  Widget build(BuildContext context) {
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
                          child: Text(time),
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
                          child: Text(DateFormat('dd/MM').format(date)),
                        )).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => sendReservation(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      backgroundColor: Colors.grey[300],
                      textStyle: const TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    child: const Text('Reservar'),
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

