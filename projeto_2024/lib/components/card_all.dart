import 'package:flutter/material.dart';
import 'package:projeto_2024/Models/models.dart';
import 'dart:math';

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

class _CardAllState extends State<CardAll> with SingleTickerProviderStateMixin {
  ModelA modelA = ModelA();
  bool isLoading = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
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
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
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
          SizedBox(
            height: widget.hvalue,
            width: widget.wvalue,
            child: Stack(
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: WavePainter(
                            animationValue: _animationController.value,
                            percentage: widget.percentage,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "${widget.percentage.toStringAsFixed(2)}%",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;
  final double percentage;

  WavePainter({required this.animationValue, required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 131, 197, 251)
      ..style = PaintingStyle.fill;

    final path = Path();

    final waveHeight = size.height / 20;
    final waveLength = size.width / 1.5;
    final baseHeight = size.height * (1 - percentage / 100);

    path.moveTo(0, size.height);
    path.lineTo(0, baseHeight);

    for (double i = 0; i <= size.width; i += 1) {
      path.lineTo(
        i,
        baseHeight - waveHeight * sin((i / waveLength * 2 * pi) + (animationValue * 2 * pi)),
      );
    }
    path.lineTo(size.width, baseHeight);
    path.lineTo(size.width, size.height);
    path.close();

    final clipPath = Path()
      ..addRRect(RRect.fromRectAndCorners(
        Rect.fromLTWH(0, 0, size.width, size.height),
        topLeft: const Radius.circular(15),
        topRight: const Radius.circular(15),
        bottomLeft: const Radius.circular(15),
        bottomRight: const Radius.circular(15),
      ));

    canvas.clipPath(clipPath);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
