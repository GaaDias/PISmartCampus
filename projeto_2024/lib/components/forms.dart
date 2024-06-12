import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_2024/Models/models.dart';
import 'dart:convert';
import 'package:projeto_2024/pages/hidrometer_page.dart';
import 'package:projeto_2024/pages/register_page.dart';
import 'package:provider/provider.dart';

class Forms extends StatefulWidget {
  const Forms({super.key});

  @override
  State<Forms> createState() => _FormsState();
}

var testColor = Colors.white;

class _FormsState extends State<Forms> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Por favor, faça login",
            style: TextStyle(
              color: Color.fromARGB(255, 84, 84, 84),
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
          const SizedBox(
            height: 70,
          ),
          GestureDetector(
            onTap: entrar,
            child: MouseRegion(
              cursor: MaterialStateMouseCursor.clickable,
              onEnter: (event) {
                setState(() {
                  testColor = const Color.fromARGB(255, 218, 218, 218);
                });
              },
              onExit: (event) {
                setState(() {
                  testColor = Colors.white;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: testColor,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(99, 0, 0, 0),
                      spreadRadius: 5,
                      blurRadius: 4,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Image.asset(
                  'assets/images/Microsoft_logo_(2012).png',
                  scale: 3.5,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Future<void> entrar() async {
    try {
      // Initialize Firebase if it hasn't been already
      await Firebase.initializeApp();

      // Use the signInWithPopup method
      OAuthProvider oAuthProvider = OAuthProvider("microsoft.com");
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithPopup(oAuthProvider);

      // Get the user's email
      User? user = userCredential.user;
      if (user != null) {
        String? email = user.email;

        if (email != null) {
          // Validate the email with your database
          bool isValid = await _validateEmail(email);
          if (isValid) {
            // Store the email using the provider
            Provider.of<EmailProvider>(context, listen: false).setEmail(email);

            // Navigate to the main page on successful validation
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => RegisterPage(
                  email: email, // Pass the authenticated email here
                ),
              ),
            );
          } else {
            // Show error if email is not authorized
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Erro 403"),
                content: const Text("E-mail não autorizado."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("OK"),
                  ),
                ],
              ),
            );
          }
        } else {
          // Handle error if email is null
          print("Error: No email found for user.");
        }
      }
    } catch (e) {
      print("Error during sign-in: $e");
      // Handle error, e.g., show a dialog with the error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Erro"),
          content: Text("Erro durante o login: $e"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  Future<bool> _validateEmail(String email) async {
    final response = await http.post(
      Uri.parse(
          'http://127.0.0.1:8000/verifica_cadastro/'), // Substitua pela URL da sua API
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': email}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error validating email: ${response.statusCode}');
      return false;
    }
  }
}
