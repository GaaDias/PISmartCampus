import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projeto_2024/Models/models.dart';
import 'package:provider/provider.dart';
import 'package:projeto_2024/pages/adm_permission_page.dart';
import 'package:projeto_2024/pages/all_charts_page.dart';
import 'package:projeto_2024/pages/artesian_well_page.dart';
import 'package:projeto_2024/pages/tela_inicial.dart';
import 'package:projeto_2024/pages/hidrometer_page.dart';
import 'package:projeto_2024/pages/register_page.dart';
import 'package:projeto_2024/pages/maintenance_page.dart';
import 'package:projeto_2024/pages/newWatertank_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyA4_o5VOKwJdsBqIQ2dT0TBJT2f-zn6QXY",
      authDomain: "acquasysbd.firebaseapp.com",
      projectId: "acquasysbd",
      storageBucket: "acquasysbd.appspot.com",
      messagingSenderId: "15792633050",
      appId: "1:15792633050:web:1abbbc640d051ea7b1e1e3",
    ),
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EmailProvider()),
        ChangeNotifierProvider(create: (context) => ModelA()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Material(
          child: LoginPage(),
        ),
      ),
    );
  }
}
