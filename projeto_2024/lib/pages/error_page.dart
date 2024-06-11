import 'package:flutter/material.dart';
import 'package:projeto_2024/colors/colors.dart';
import 'package:projeto_2024/pages/hidrometer_page.dart';

class ErroPage extends StatefulWidget {
  final String mensagemErro;
  final String codigoErro;
  const ErroPage({
    super.key,
    required this.mensagemErro,
    required this.codigoErro,
  });

  @override
  State<ErroPage> createState() => _ErroPageState();
}

class _ErroPageState extends State<ErroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.mensagemErro,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.codigoErro,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 30,
              ),
              FloatingActionButton.extended(
                  backgroundColor: azulPadrao,
                  label: const Text("Voltar para pagina inicial"),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HidrometerPage()),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
