import 'package:baco/base/base.dart';
import 'package:baco/common/adapterHelper/responsive_sizer.dart';
import 'package:baco/widgets/custom/customContenair.dart';
import 'package:baco/widgets/custom/customImageWidget.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

class RoutePage extends BaseWidget {
  final int chargeOff;
  final FunctionEmptyCallback onChargeOff;
  const RoutePage(
      {required this.chargeOff, required this.onChargeOff, super.key});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _RouteState();
  }
}

class Ground {
  int index;
  GlobalKey key;
  String img;
  bool isLefttEnd;
  Color testColor;
  bool isGoingUp;
  bool isGoingDown;

  // bool isQuestion;
  Ground({
    required this.index,
    required this.key,
    required this.img,
    required this.testColor,
    this.isGoingUp = false,
    this.isGoingDown = false,
    this.isLefttEnd = false,
  });
}

class Car {
  Offset position;
  Ground ground;
  Direction direction;
  String image;
  int quarterTurns;

  Car(
      {required this.direction,
      required this.ground,
      required this.position,
      this.image = "voiture",
      this.quarterTurns = 1});
}

enum Direction {
  LEFT,
  RIGHT,
  TOP,
  BOTTOM,
}

class Battery {
  int pourcentage;
  String status;

  Battery({required this.pourcentage, required this.status});
}

class _RouteState extends BaseWidgetState<RoutePage> {
  List<Ground> list = [];
  late Car car;
  int hour = 00;
  bool onTap = false;
  bool passEight = false;
  bool passtweetyTwo = false;
  bool passFourFour = false;

  bool passFivetweent = false;
  bool passtweetyThreeS = false;
  bool passFourFourNine = false;

  static const int carDuration = 1000;

  Battery battery = Battery(pourcentage: 100, status: "Charger"); //Battery

  double _xx(double x) {
    return 100.w / 1920.0 * x;
  }

  double _yy(double y) {
    return 100.h / 1200 * y;
  }

  genereteGround() {
    bool isNewLine = false;
    for (var i = 1; i <= 50; i++) {
      bool isLefttEnd = false;
      String img = "route";
      Color testColor = Colors.red;
      if (isNewLine) {
        testColor = Colors.green;
        img = "angle_hautgauche";
        if (i == 21 || i == 41) {
          img = "angle_basgauche";
        }
      }
      if (i % 10 == 0) {
        isLefttEnd = true;
        isNewLine = true;
        testColor = Colors.blue;
        img = "angle_hautdroit";
        if (i % 20 == 0) {
          img = "angle_basdroit";
        }
      } else {
        isNewLine = false;
      }
      if (i == 50) {
        img = "route";
      }
      bool isGoingUp = (i == 8 || i == 22 || i == 44);
      bool isGoingDown = (i == 15 || i == 37 || i == 49);
      if (isGoingDown) {
        img = "descent";
      }
      if (isGoingUp) {
        img = "pente";
      }
      Ground g = Ground(
        index: i,
        key: GlobalKey(),
        img: img,
        isLefttEnd: isLefttEnd,
        isGoingUp: isGoingUp,
        isGoingDown: isGoingDown,
        testColor: testColor,
      );
      list.add(g);
    }
    car = Car(
        direction: Direction.LEFT,
        ground: list[0],
        position: const Offset(0, 0));
  }

  Offset offset = const Offset(0, 0);

  @override
  void initState() {
    genereteGround();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant RoutePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.chargeOff != oldWidget.chargeOff && widget.chargeOff > 0) {
      print("here----------energyOff--------------- ${widget.chargeOff}");
      removeBattery(energy: widget.chargeOff);
    }
  }

  void removeBattery({required int energy}) {
    battery.pourcentage -= energy;
    widget.onChargeOff.call();
    // rebuild();
    moveCar(moveCase: 10);
  }
  // void removeFromBattery({required int add}) {
  //   add += car.ground.index;
  //   if (!passFivetweent && (add > 10 && add < 15)) {
  //     battery.pourcentage -= 2;
  //     passFivetweent = true;
  //   }
  //   if (!passtweetyThreeS && (add > 30 && add < 37)) {
  //     battery.pourcentage -= 2;
  //     passtweetyThreeS = true;
  //   }
  //   if (!passFourFourNine && (add > 40 && add < 49)) {
  //     battery.pourcentage -= 2;
  //     passFourFourNine = true;
  //   }

  //   //--
  //   if (!passEight && add > 8) {
  //     battery.pourcentage += 1;
  //     passEight = true;
  //   }
  //   if (!passtweetyTwo && add > 22) {
  //     battery.pourcentage += 1;
  //     passtweetyTwo = true;
  //   }
  //   if (!passFourFour && add > 44) {
  //     battery.pourcentage += 1;
  //     passFourFour = true;
  //   }
  //   setState(() {});
  // }

  moveCar({required int moveCase}) async {
    if (car.ground.index == 50) {
      return;
    }
    if (car.quarterTurns == 1) {
      int add = car.ground.index + moveCase;
      if (add <= 10 || (add > 20 && add <= 30) || (add > 40 && add <= 60)) {
        if (add > 50) {
          add = 50;
        }
        Ground g = list.firstWhere((element) => element.index == add);
        car.position = getOffsetsPositionsLocal(g.key);
        car.ground = g;
        setState(() {});
      } else {
        int a = 10;
        int b = 20;
        if (car.ground.index > 20) {
          a = 30;
          b = 40;
        }
        // if (car.ground.index > 10) {
        //   a = 11;
        //   b = 21;
        // }
        print("here-------------------------1111 ${car.ground.index}");
        int rest = a - car.ground.index;
        rest = moveCase - rest;
        Ground g = list.firstWhere((element) => element.index == a);
        car.position = getOffsetsPositionsLocal(g.key);
        car.ground = g;

        setState(() {});
        await Future.delayed(const Duration(milliseconds: carDuration));
        car.quarterTurns = 2;
        g = list.firstWhere((element) => element.index == b);
        car.position = getOffsetsPositionsLocal(g.key);
        car.ground = g;

        setState(() {});
        await Future.delayed(const Duration(milliseconds: carDuration));
        g = list.firstWhere((element) => element.index == (b - rest));
        car.position = getOffsetsPositionsLocal(g.key);
        car.quarterTurns = 3;
        car.ground = g;

        setState(() {});
      }
      // removeFromBattery(add: add.abs());
    } else if (car.quarterTurns == 3) {
      int m = car.ground.index - moveCase;
      print("here-------------------------2222222 $m");
      if (((m >= 11 && m < 20) || (m >= 31 && m <= 11))) {
        // removeFromBattery(add: m.abs());
        print("here----------------------------???? $m");
        if (car.ground.index == 31 || (m >= 31 && m <= 11)) {
          int a = 31;
          int b = 41;
          int rest = a - car.ground.index;

          rest = moveCase - rest;

          Ground g = list.firstWhere((element) => element.index == a);
          car.position = getOffsetsPositionsLocal(g.key);
          car.ground = g;

          setState(() {});
          await Future.delayed(const Duration(seconds: 1));
          car.quarterTurns = 2;
          g = list.firstWhere((element) => element.index == b);
          car.position = getOffsetsPositionsLocal(g.key);
          car.ground = g;
          setState(() {});
          await Future.delayed(const Duration(seconds: 1));
          g = list.firstWhere((element) => element.index == (b + rest.abs()));
          car.position = getOffsetsPositionsLocal(g.key);
          car.quarterTurns = 1;
          car.ground = g;
          setState(() {});
        } else {
          Ground g = list.firstWhere((element) => element.index == m);
          car.position = getOffsetsPositionsLocal(g.key);
          car.ground = g;
          setState(() {});
        }
      } else {
        print("here----------------------------a ba ba ${car.ground.index}");

        int a = 10;
        int b = 20;

        if (car.ground.index > 10) {
          a = 11;
          b = 21;
        }
        if (car.ground.index > 30 && car.ground.index < 40) {
          print("here-------------------------->10 ==[] ${car.ground.index}");

          a = 31;
          b = 41;
        }

        int rest = a - car.ground.index;
        // removeFromBattery(add: rest.abs());
        print("rest:==== $rest ");

        rest = moveCase - rest.abs();
        // removeFromBattery(add: rest.abs());
        print("rest: ......$rest ");

        rest = rest.abs();

        Ground g = list.firstWhere((element) => element.index == a);
        car.position = getOffsetsPositionsLocal(g.key);
        car.ground = g;
        setState(() {});
        await Future.delayed(const Duration(seconds: 1));
        car.quarterTurns = 2;
        g = list.firstWhere((element) => element.index == b);
        car.position = getOffsetsPositionsLocal(g.key);
        car.ground = g;
        setState(() {});
        await Future.delayed(const Duration(seconds: 1));
        print("rest: $rest b: $b");

        g = list.firstWhere((element) => element.index == (b + rest));
        car.position = getOffsetsPositionsLocal(g.key);
        car.quarterTurns = 1;
        car.ground = g;
        setState(() {});
      }
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
          color: const Color.fromRGBO(91, 188, 146, 1),
          child: Stack(fit: StackFit.expand, children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: s.height,
                width: s.width,
                child: GridView.count(
                  crossAxisCount: 10,
                  children: List.generate(list.length, (index) {
                    Ground g = list[index];
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                          key: g.key,
                          color: index % 2 == 0 ? Colors.amber : g.testColor,
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              RotatedBox(
                                quarterTurns: g.isGoingDown ? 2 : 0,
                                child: CustomImageWidget(
                                  g.img,
                                  height: yy(p: 20, s: s),
                                  fit: BoxFit.cover,
                                  directory: "assets/route",
                                ),
                              ),
                              // Text("${g.index}"),
                            ],
                          )
                          //

                          ),
                    );
                  }),
                ),
              ),
            ),
            AnimatedPositioned(
                top: car.position.dy,
                left: car.position.dx,
                duration: const Duration(milliseconds: carDuration),
                child: RotatedBox(
                  quarterTurns: car.quarterTurns,
                  child: SizedBox(
                    height: _yy(150),
                    width: _xx(150),
                    child: CustomImageWidget(
                      car.image,
                      // fit: BoxFit.fitWidth,
                      directory: "assets/route",
                    ),
                  ),
                )),
            Align(
              alignment: Alignment.bottomLeft,
              child: GestureDetector(
                onTap: () {
                  // battery.status = "chargement";
                  // setState(() {});
                  // if (IsFavorable) {
                  //   battery.pourcentage += 4;
                  // } else {
                  //   battery.pourcentage += 2;
                  // }
                  // if (battery.pourcentage >= 100) {
                  //   battery.pourcentage = 100;
                  // }
                  // battery.status = "charger";
                  // hour++;
                  // setState(() {});

                  // getData();
                  moveCar(moveCase: 10);
                },
                child: SizedBox(
                  height: _yy(220),
                  width: _xx(250),
                  // color: Colors.blue,
                  child: LiquidCircularProgressIndicator(
                    value: battery.pourcentage / 100, // Defaults to 0.5.

                    valueColor: AlwaysStoppedAnimation(battery.pourcentage >= 50
                        ? Colors.green
                        : Colors
                            .red), // Defaults to the current Theme's accentColor.
                    backgroundColor: Colors
                        .white, // Defaults to the current Theme's backgroundColor.
                    borderColor: battery.pourcentage >= 50
                        ? Colors.green
                        : Colors
                            .red, // Defaults to the current Theme's accentColor.
                    borderWidth: 5.0,
                    direction: Axis
                        .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${battery.pourcentage}%",
                          style: TextStyle(
                              color: battery.pourcentage > 50
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        Text(
                          battery.status,
                          style: TextStyle(
                              color: battery.pourcentage > 50
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Positioned(
            //     bottom: _yy(0),
            //     left: _xx(700),
            //     child: SizedBox(
            //       height: _yy(320),
            //       width: _xx(350),
            //       // color: Colors.black,
            //       child: IconButton(
            //         icon: const Icon(Icons.home),
            //         onPressed: () {
            //           onTap = false;
            //           setState(() {});
            //           moveCar(moveCase: 2);
            //         },
            //       ),
            //     )),
            // Positioned(
            //     bottom: _yy(0),
            //     right: _xx(200),
            //     child: SizedBox(
            //       height: _yy(320),
            //       width: _xx(350),
            //       // color: Colors.orange,
            //       child: GestureDetector(
            //         onTap: () {
            //           if (!onTap) {
            //             onTap = true;
            //             setState(() {});
            //           }
            //         },
            //         child: Center(
            //           child: Container(
            //               width: 200,
            //               height: 200,
            //               decoration: BoxDecoration(
            //                   color: onTap ? Colors.blue : Colors.grey[300],
            //                   shape: BoxShape.circle,
            //                   boxShadow: [
            //                     BoxShadow(
            //                         color: onTap
            //                             ? Colors.blue
            //                             : const Color(0xFF757575),
            //                         offset: const Offset(4.0, 4.0),
            //                         blurRadius: 15.0,
            //                         spreadRadius: 1.0),
            //                     BoxShadow(
            //                         color: onTap ? Colors.blue : Colors.white,
            //                         offset: const Offset(-4.0, -4.0),
            //                         blurRadius: 15.0,
            //                         spreadRadius: 1.0),
            //                   ],
            //                   gradient: LinearGradient(
            //                       begin: Alignment.topLeft,
            //                       end: Alignment.bottomRight,
            //                       colors: [
            //                         onTap
            //                             ? Colors.red
            //                             : const Color(0xFFEEEEEE),
            //                         onTap
            //                             ? Colors.red
            //                             : const Color(0xFFE0E0E0),
            //                         onTap
            //                             ? Colors.red
            //                             : const Color(0XFFBDBDBD),
            //                         onTap
            //                             ? Colors.red
            //                             : const Color(0xFF9E9E9E),
            //                       ],
            //                       stops: const [
            //                         0.1,
            //                         0.3,
            //                         0.8,
            //                         0.9
            //                       ])),
            //               child: Center(
            //                   child: Text(
            //                 "Lancer le dé",
            //                 style: TextStyle(
            //                   color: onTap ? Colors.white : Colors.black,
            //                 ),
            //               ))),
            //         ),
            //       ),
            //     )),
          ]),
        );
      }),
    );
  }
}
