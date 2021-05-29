import 'dart:ui';

import 'package:flutter/material.dart';

class LineGraphPainter extends CustomPainter {
  LineGraphPainter({
    required double height,
    required double minY,
    required double yAxisSpacing,
    required double yBoxHeight,
    required List<double> data,
  })  : this.height = height,
        this.minY = minY,
        this.yAxisSpacing = yAxisSpacing,
        this.yBoxHeight = yBoxHeight,
        this.data = data;

  final double height;
  final double minY;
  final double yAxisSpacing;
  final double yBoxHeight;
  final List<double> data;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    List<Offset> points = [];

    /// 첫 시작 지점
    /// y축 출력시 + 50.0
    double startPoint = 50.0;

    double xAxisCenter = 40.0;

    double chartHeight = height - 40.0;

    /// Offset(xAxis, yAxis)
    for (int i = 0; i < data.length - 1; i++) {
      points.add(Offset(startPoint + (xAxisCenter * i), chartHeight - (data[i] - (minY - (yAxisSpacing / 2))) * (yBoxHeight / yAxisSpacing) - 9.0));
      points.add(Offset(startPoint + xAxisCenter * (i + 1), chartHeight - (data[i + 1] - (minY - (yAxisSpacing / 2))) * (yBoxHeight / yAxisSpacing) - 9.0));
    }

    canvas.drawPoints(PointMode.lines, points, paint);
  }

  @override
  bool shouldRepaint(LineGraphPainter oldDelegate) {
    return oldDelegate.yAxisSpacing != yAxisSpacing || oldDelegate.data != data;
  }
}
