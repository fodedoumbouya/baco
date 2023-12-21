import 'package:baco/base/base.dart';
import 'package:baco/models/enum.dart';
import 'package:baco/pages/gameView.dart';
import 'package:baco/widgets/custom/customContenair.dart';
import 'package:flutter/material.dart';
import 'package:game_levels_scrolling_map/game_levels_scrolling_map.dart';
import 'package:game_levels_scrolling_map/model/point_model.dart';

class Home extends BaseWidget {
  const Home({super.key});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _HomeState();
  }
}

class _HomeState extends BaseWidgetState<Home> {
  List<int> indexToShow = [1, 3, 4, 7];
  int index = 0;
  @override
  void initState() {
    fillTestData();
    super.initState();
  }

  List<PointModel> points = [];

  void fillTestData() {
    for (int i = 0; i < 8; i++) {
      points.add(PointModel(100, testWidget(i)));
    }
  }

  Widget testWidget(int order) {
    bool contains = indexToShow.contains(order);
    if (contains) {
      index++;
    }
    return contains
        ? InkWell(
            hoverColor: Colors.blue,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  "assets/drawable/map_horizontal_point.png",
                  fit: BoxFit.fitWidth,
                  width: 100,
                ),
                Text("$index",
                    style: const TextStyle(color: Colors.black, fontSize: 40))
              ],
            ),
            onTap: () {
              toPage(const GamesView(type: GameType.house));
              // showDialog(
              //   context: context,
              //   builder: (BuildContext context) {
              //     return AlertDialog(
              //       content: Text("Point $order"),
              //       actions: <Widget>[
              //         ElevatedButton(
              //           child: const Text("OK"),
              //           onPressed: () {
              //             Navigator.of(context).pop();
              //           },
              //         ),
              //       ],
              //     );
              //   },
              // );
            },
          )
        : const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(builder: (context, p1) {
        Size s = p1.biggest;
        return CustomContainer(
            h: s.height,
            w: s.width,
            color: Colors.white,
            child: GameLevelsScrollingMap.scrollable(
              imageUrl: "assets/drawable/map_horizontal.png",
              direction: Axis.horizontal,
              svgUrl: 'assets/svg/map_horizontal.svg',
              points: points,
            ));
      }),
    );
  }
}
