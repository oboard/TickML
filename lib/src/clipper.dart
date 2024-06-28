import 'dart:math';

import 'package:flutter/rendering.dart';

class ArcClipper extends CustomClipper<Path> {
  final double startAngle, sweepAngle;

  ArcClipper(this.startAngle, this.sweepAngle);

  @override
  Path getClip(Size size) {
    var path = Path();
    // path.moveTo(size.width / 2, size.height / 2); //从图片的中间上面坐标
    // path.lineTo()
    path.addArc(
      Rect.fromLTRB(
        0,
        0,
        size.width,
        size.height,
      ),
      startAngle * (pi / 180.0),
      sweepAngle * (pi / 180.0),
    );
    path.lineTo(size.width / 2, size.height / 2);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
