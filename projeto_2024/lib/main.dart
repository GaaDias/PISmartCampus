import 'package:flutter/material.dart';
import 'package:projeto_2024/pages/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projeto_2024/pages/all_charts_page.dart';
import 'package:projeto_2024/pages/artesian_well_page.dart';
import 'package:projeto_2024/pages/login_page.dart';
import 'package:projeto_2024/pages/hidrometer_page.dart';

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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Material(
        child: (ArtesianWellPage()),
      ),
    );
  }
}
