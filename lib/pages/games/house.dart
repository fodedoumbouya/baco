import 'package:baco/base/base.dart';
import 'package:baco/models/enum.dart';
import 'package:baco/widgets/custom/customContenair.dart';
import 'package:flutter/material.dart';

class House extends BaseWidget {
  final HouseType type;
  const House({required this.type, super.key});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _HouseState();
  }
}

class _HouseState extends BaseWidgetState<House> {
  String image = "";
  List<HouseType> left = [
    HouseType.bedroomLight,
    HouseType.kitchen,
    HouseType.kitchen
  ];
  List<HouseType> right = [
    HouseType.bathroom,
    HouseType.bedroomDark,
    HouseType.garrage,
    HouseType.livingRoomDark,
    HouseType.livingRoomLight
  ];
  bool isLeft = false;
/* 
Bathroom
Right
characterRight

bedroom Dark
Right
characterRight

Bedroom Light
Left
characterLeft


kitchen
Left
characterLeft

Garrage
Right
characterRight


living room
right: 00%
bottom: 0%
*/

  @override
  void initState() {
    super.initState();
    isLeft = left.contains(widget.type);
    getImage();
  }

  getImage() {
    switch (widget.type) {
      case HouseType.bathroom:
        image = "bathroom";
        break;
      case HouseType.bedroomDark:
        image = "bedroomDark";
        break;
      case HouseType.bedroomLight:
        image = "bedroomLight";
        break;
      case HouseType.kitchen:
        image = "kitchen";
        break;
      case HouseType.garrage:
        image = "garage";
        break;
      case HouseType.livingRoomDark:
        image = "livingRoomDark";
        break;
      case HouseType.livingRoomLight:
        image = "livingRoomLight";
        break;
      default:
        image = "bathroom";
        break;
    }
    rebuild();
  }

  @override
  void didUpdateWidget(covariant House oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.type != widget.type) {
      isLeft = left.contains(widget.type);
      getImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (p0, p1) {
        Size s = p1.biggest;
        return CustomContainer(
          h: s.height,
          w: s.width,
          image: image,
          centerSlice: Rect.fromLTWH(0, 0, s.width, s.height),
          child: Stack(
            children: [
              Positioned(
                  bottom: yy(p: -10, s: s),
                  right: isLeft ? null : xx(p: 0, s: s),
                  left: isLeft ? xx(p: 0, s: s) : null,
                  child: CustomContainer(
                    h: yy(p: 100, s: s),
                    w: xx(p: 20, s: s),
                    image: isLeft ? "characterLeft" : "characterRight",
                    fit: BoxFit.fitHeight,
                  ))
            ],
          ),
        );
      }),
    );
  }
}
