class BarGraphs {
  final int x;
  final double y;

  BarGraphs({
    required this.x,
    required this.y,
  });
}

class BarData {
  final double segAmount;
  final double terAmount;
  final double quaAmount;
  final double quiAmount;

  BarData({
    required this.segAmount,
    required this.terAmount,
    required this.quaAmount,
    required this.quiAmount,
  });

  List<BarGraphs> barData = [];

  void initializeBarData() {
    barData = [
      //
      BarGraphs(x: 0, y: segAmount),

      //
      BarGraphs(x: 1, y: terAmount),

      //
      BarGraphs(x: 2, y: quaAmount),

      //
      BarGraphs(x: 3, y: quiAmount),
    ];
  }
}
