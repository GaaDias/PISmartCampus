import 'package:flutter/material.dart';
import 'package:projeto_2024/pages/hidrometer_page.dart';

class TopPages extends StatefulWidget {
  final Widget rota;
  final String texto;
  const TopPages({
    super.key,
    required this.texto,
    required this.rota,
  });

  @override
  State<TopPages> createState() => _TopPagesState();
}

class _TopPagesState extends State<TopPages> {
  var corBotao = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: MaterialStateMouseCursor.clickable,
      onEnter: (event) => setState(() {
        corBotao = const Color.fromARGB(76, 158, 158, 158);
      }),
      onExit: (event) => setState(() {
        corBotao = Colors.transparent;
      }),
      child: GestureDetector(
        onTap: goToPage,
        child: Container(
          decoration: BoxDecoration(
            color: corBotao,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(10),
          child: Text(
            widget.texto,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  void goToPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Material(child: widget.rota),
      ),
    );
  }
}
