import 'dart:async';
import 'package:flutter/material.dart';

class ClockWidget extends StatefulWidget {
  final int tempoReload;
  const ClockWidget({super.key, required this.tempoReload});

  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  late Timer _timer;
  late Duration _timeLeft;

  @override
  void initState() {
    super.initState();
    _timeLeft = Duration(minutes: widget.tempoReload);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft.inSeconds > 0) {
          _timeLeft -= const Duration(seconds: 1);
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int minutes = _timeLeft.inMinutes;
    int seconds = _timeLeft.inSeconds % 60;

    return Text(
      "Time until next update: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }
}
