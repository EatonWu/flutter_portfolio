import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

List<MaterialColor> generateRandomListOfMaterialColors(int quantity) {
  return List<MaterialColor>.generate(
    quantity,
    (index) => Colors.primaries[index % Colors.primaries.length],
  );
}

List<Color> generateRandomListOfColors(int quantity) {
  return List<Color>.generate(
    quantity,
    (index) => Colors.primaries[index % Colors.primaries.length],
  );
}

RadialGradientColorSplash radialGradientColorSplash(Color startColor, Color endColor) {
  return RadialGradientColorSplash(
    startColor: startColor,
    endColor: endColor,
  );
}

class RadialGradientColorSplash extends StatelessWidget {
  final Color startColor;
  final Color endColor;
  final double minSize;
  final double maxSize;

  const RadialGradientColorSplash({
    super.key,
    required this.startColor,
    required this.endColor,
    this.minSize = 50.0,
    this.maxSize = 150.0,
  });

  @override
  Widget build(BuildContext context) {
    // Generate random size between minSize and maxSize
    var randomSize = Random().nextDouble() * (maxSize - minSize) + minSize;
    var middleColor = Color.lerp(startColor, endColor, 0.5) ?? Colors.white;
    var radius = randomSize / 2;
    return LayoutBuilder(
      builder: (context, constraints) {
        var randomPositionTop = (Random().nextDouble() * constraints.maxHeight) - radius;
        var randomPositionLeft = (Random().nextDouble() * constraints.maxWidth) - radius;
        return Stack(
          children: [
            Positioned(
              top: randomPositionTop,
              left: randomPositionLeft,
              child: Container(
                width: randomSize,
                height: randomSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      startColor,
                      middleColor,
                      endColor,
                    ],
                    stops: const [0.3, 0.7, 1.0],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
