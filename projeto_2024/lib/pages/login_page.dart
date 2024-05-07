import 'package:flutter/material.dart';
import 'package:projeto_2024/components/forms.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.blue,
          ),
        ),
        const Expanded(
          flex: 1,
          child: Forms()
        )
      ],
    );
  }
}
