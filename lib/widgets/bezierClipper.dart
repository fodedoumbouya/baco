// ignore_for_file: file_names

import 'package:flutter/material.dart';

class BezierClipper extends CustomClipper<Path> {
  final int state;
  BezierClipper(this.state);

  Path _getInitialClip(Size size) {
    Path path = Path();
    final double xScaling = size.width / 360;
    final double yScaling = size.height / 370; //363.15;
    path.lineTo(
        -0.003999999999997783 * xScaling, 341.78499999999997 * yScaling);
    path.cubicTo(
      -0.003999999999997783 * xScaling,
      341.78499999999997 * yScaling,
      23.461000000000002 * xScaling,
      363.15099999999995 * yScaling,
      71.553 * xScaling,
      363.15099999999995 * yScaling,
    );
    path.cubicTo(
      119.645 * xScaling,
      353.15099999999995 * yScaling,
      142.21699999999998 * xScaling,
      300.186 * yScaling,
      203.29500000000002 * xScaling,
      307.21 * yScaling,
    );
    path.cubicTo(
      264.373 * xScaling,
      314.234 * yScaling,
      282.666 * xScaling,
      333.47299999999996 * yScaling,
      338.408 * xScaling,
      333.47299999999996 * yScaling,
    );
    path.cubicTo(
      394.15000000000003 * xScaling,
      333.47299999999996 * yScaling,
      413.99600000000004 * xScaling,
      254.199 * yScaling,
      413.99600000000004 * xScaling,
      254.199 * yScaling,
    );
    path.cubicTo(
      413.99600000000004 * xScaling,
      254.199 * yScaling,
      413.99600000000004 * xScaling,
      0 * yScaling,
      413.99600000000004 * xScaling,
      0 * yScaling,
    );
    path.cubicTo(
      413.99600000000004 * xScaling,
      0 * yScaling,
      -0.003999999999976467 * xScaling,
      0 * yScaling,
      -0.003999999999976467 * xScaling,
      0 * yScaling,
    );
    path.cubicTo(
      -0.003999999999976467 * xScaling,
      0 * yScaling,
      -0.003999999999997783 * xScaling,
      341.78499999999997 * yScaling,
      -0.003999999999997783 * xScaling,
      341.78499999999997 * yScaling,
    );
    return path;
  }

  Path _getFinalClip(Size size) {
    Path path = Path();
    // final double _xScaling = size.width / 414;
    // final double _yScaling = size.height / 301.69;
    final double xScaling = size.width / 300;
    final double yScaling = size.height / 310; //363.15;
    path.lineTo(-0.003999999999997783 * xScaling, 217.841 * yScaling);
    path.cubicTo(
      -0.003999999999997783 * xScaling,
      217.841 * yScaling,
      19.14 * xScaling,
      265.91999999999996 * yScaling,
      67.233 * xScaling,
      265.91999999999996 * yScaling,
    );
    path.cubicTo(
      115.326 * xScaling,
      265.91999999999996 * yScaling,
      112.752 * xScaling,
      234.611 * yScaling,
      173.83299999999997 * xScaling,
      241.635 * yScaling,
    );
    path.cubicTo(
      234.914 * xScaling,
      248.659 * yScaling,
      272.866 * xScaling,
      301.691 * yScaling,
      328.608 * xScaling,
      301.691 * yScaling,
    );
    path.cubicTo(
      384.34999999999997 * xScaling,
      301.691 * yScaling,
      413.99600000000004 * xScaling,
      201.977 * yScaling,
      413.99600000000004 * xScaling,
      201.977 * yScaling,
    );
    path.cubicTo(
      413.99600000000004 * xScaling,
      201.977 * yScaling,
      413.99600000000004 * xScaling,
      0 * yScaling,
      413.99600000000004 * xScaling,
      0 * yScaling,
    );
    path.cubicTo(
      413.99600000000004 * xScaling,
      0 * yScaling,
      -0.003999999999976467 * xScaling,
      0 * yScaling,
      -0.003999999999976467 * xScaling,
      0 * yScaling,
    );
    path.cubicTo(
      -0.003999999999976467 * xScaling,
      0 * yScaling,
      -0.003999999999997783 * xScaling,
      217.841 * yScaling,
      -0.003999999999997783 * xScaling,
      217.841 * yScaling,
    );
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;

  @override
  Path getClip(Size size) =>
      state == 1 ? _getInitialClip(size) : _getFinalClip(size);
}
