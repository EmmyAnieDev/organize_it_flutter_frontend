import 'package:flutter/material.dart';

class DiagonalProgressLines extends StatelessWidget {
  final double progress;
  final double height;
  final int numberOfLines;

  const DiagonalProgressLines({
    super.key,
    this.progress = 50,
    this.height = 25,
    this.numberOfLines = 10,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: DiagonalLinesPainter(
          progress: progress,
          numberOfLines: numberOfLines,
        ),
      ),
    );
  }
}

class DiagonalLinesPainter extends CustomPainter {
  final double progress;
  final int numberOfLines;

  DiagonalLinesPainter({
    required this.progress,
    required this.numberOfLines,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const spacing = 25.0;
    const diagonal = 20.0;

    for (var i = 0; i < numberOfLines; i++) {
      final x = i * spacing;
      final progress = x / size.width;

      // Create gradient for each line
      final shader = LinearGradient(
        colors: [
          progress <= this.progress
              ? const Color(0xFFE056C5).withOpacity(0.8)
              : const Color(0xFFE056C5).withOpacity(0.3),
          progress <= this.progress
              ? const Color(0xFF4B7BF5).withOpacity(0.8)
              : const Color(0xFF4B7BF5).withOpacity(0.3),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(x, 0, spacing, size.height));

      paint.shader = shader;

      // Draw diagonal line
      canvas.drawLine(
        Offset(x - diagonal, size.height),
        Offset(x + diagonal, 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(DiagonalLinesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
