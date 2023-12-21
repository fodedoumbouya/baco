import 'package:flutter/material.dart';
import 'package:stroke_text/stroke_text.dart';

class CustomStrokeTextWidget extends StatelessWidget {
  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final double? size;
  final bool withOverflow;
  final TextDecoration? decoration;
  final Paint? foreground;
  final String? fontFamily;
  final Color strokeColor;
  const CustomStrokeTextWidget(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.size,
    this.withOverflow = true,
    this.decoration,
    this.foreground,
    this.fontFamily,
    this.strokeColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    // TextOverflow? overflow = withOverflow ? TextOverflow.ellipsis : null;
    return StrokeText(
      text: text,
      strokeColor: strokeColor,
      textStyle: TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontSize: size,
          // overflow: overflow,

          decoration: decoration,
          foreground: foreground,
          fontFamily: fontFamily),
    );
  }
}
