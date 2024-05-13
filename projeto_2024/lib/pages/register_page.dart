import 'package:flutter/material.dart';
import 'package:projeto_2024/colors/colors.dart';


class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: azulPadrao, 
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/images/LogoApp.png', 
                width: 50, 
                height: 50, 
              ),
            ),
            const Padding (
                padding: EdgeInsets.all(30.0),
                child: Text(
                    'Perfil',
                    style: TextStyle(
                        fontSize: 20, 
                    ),
                ),
            )
          ],
        ),
      ),
      body: Container(),
    );
  }
}
