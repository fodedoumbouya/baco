import 'package:flutter/material.dart';

class CustomImageWidget extends StatelessWidget {
  final String img;
  final BoxFit? fit;
  final String imgType;
  final double? width;
  final double? height;
  final String? directory;
  const CustomImageWidget(
    this.img, {
    super.key,
    this.fit,
    this.imgType = "png",
    this.width,
    this.height,
    this.directory = "images",
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      key: key,
      "$directory/$img.$imgType",
      fit: fit,
      height: height,
      width: width,
    );
  }
}
