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
  final double sexAmount;
  final double sabAmount;
  final double domAmount;

  BarData({
    required this.segAmount,
    required this.terAmount,
    required this.quaAmount,
    required this.quiAmount,
    required this.sexAmount,
    required this.sabAmount,
    required this.domAmount,
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
    
      //
      BarGraphs(x: 4, y: sexAmount),
    
      //
      BarGraphs(x: 5, y: sabAmount),
    
      //
      BarGraphs(x: 6, y: domAmount),
    
    ];
  }
}
