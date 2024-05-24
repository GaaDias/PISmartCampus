import 'package:flutter/material.dart';
import 'package:projeto_2024/Models/models.dart';

class CardAll extends StatefulWidget {
  const CardAll({
    super.key,
    required this.hvalue,
    required this.wvalue,
    required this.index,
    required this.percentage,
  });
  final int index;
  final double? hvalue;
  final double? wvalue;
  final double percentage;

  @override
  State<CardAll> createState() => _CardAllState();
}

class _CardAllState extends State<CardAll> {
  ModelA modelA = ModelA();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      await modelA.getHidrometer();
    } catch (error) {
      print("Error fetching data: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : buildCard();
  }

  Widget buildCard() {
    double coloredContainerHeight = widget.hvalue! * (widget.percentage / 100);
    return Column(
      children: [
        Text(
          "Caixa ${widget.index}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Stack(
          children: [
            Container(
              height: widget.hvalue,
              width: widget.wvalue,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(15),
              ),
              alignment: Alignment.bottomCenter,
              child: Container(
                height: coloredContainerHeight,
                width: widget.wvalue,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 131, 197, 251),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(15),
                    top: Radius.circular(15),
                  ),
                ),
                child: Center(
                  child: Text(
                    "${widget.percentage.toStringAsFixed(2)}%",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
