import 'package:flutter/material.dart';
import 'package:projeto_2024/Models/models.dart';
import 'package:projeto_2024/components/forms.dart';
import 'package:projeto_2024/pages/all_charts_page.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    final modelA = Provider.of<ModelA>(context, listen: false);
    modelA.startTimer(); // Start the timer to fetch data every 15 minutes
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Image.asset(
            'assets/images/Designer.jpeg',
            fit: BoxFit.fill,
          ),
        ),
        const Expanded(
          flex: 1,
          child: Forms(),
        )
      ],
    );
  }
}
