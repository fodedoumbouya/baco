import 'dart:io';

import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Widget? child;
  final double? h;
  final double? w;
  final double? allM;
  final double allP;
  final double topM;
  final double bottomM;
  final double leftM;
  final double rightM;
  final double radius;
  final Alignment? alig;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final String? image;
  final BoxFit? fit;
  final Alignment decoAlignment;
  final String imgType;
  final List<BoxShadow>? boxShadow;
  final BoxShape boxShape;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final Rect? centerSlice;
  final Gradient? gradient;
  final String? path;
  final bool isAssetImage;

  const CustomContainer({
    super.key,
    this.child,
    this.h,
    this.w,
    this.allM,
    this.allP = 0,
    this.topM = 0,
    this.bottomM = 0,
    this.leftM = 0,
    this.rightM = 0,
    this.radius = 0,
    this.alig,
    this.padding,
    this.color,
    this.image,
    this.fit = BoxFit.fill,
    this.decoAlignment = Alignment.topCenter,
    this.imgType = "png",
    this.boxShadow,
    this.boxShape = BoxShape.rectangle,
    this.borderRadius,
    this.border,
    this.centerSlice,
    this.gradient,
    this.path = "assets/drawable",
    this.isAssetImage = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      alignment: alig,
      margin: allM == null
          ? EdgeInsets.only(
              left: leftM, right: rightM, bottom: bottomM, top: topM)
          : EdgeInsets.all(allM!),
      padding: padding ?? EdgeInsets.all(allP),
      decoration: BoxDecoration(
        color: color,
        shape: boxShape,
        boxShadow: boxShadow,
        gradient: gradient,
        image: image == null
            ? null
            : DecorationImage(
                image: isAssetImage
                    ? AssetImage('$path/$image.$imgType')
                    : Image.file(File(image!)).image,
                scale: MediaQuery.of(context).devicePixelRatio,
                centerSlice: centerSlice,
                fit: fit,
                colorFilter: color == null
                    ? null
                    : ColorFilter.mode(color!, BlendMode.color),
                alignment: decoAlignment),
        border: border,
        borderRadius: boxShape != BoxShape.rectangle
            ? null
            : borderRadius ?? BorderRadius.circular(radius),
      ),
      height: h,
      width: w,
      child: child,
    );
  }
}
