import 'package:animated_digit/animated_digit.dart';
import 'package:baco/base/base.dart';
import 'package:baco/common/adapterHelper/responsive_sizer.dart';
import 'package:baco/common/constant.dart';
import 'package:baco/models/enum.dart';
import 'package:baco/pages/gameView.dart';
import 'package:baco/widgets/custom/custom.dart';
import 'package:baco/widgets/custom/customContenair.dart';
import 'package:baco/widgets/custom/customImageWidget.dart';
import 'package:flutter/material.dart';
import 'package:game_levels_scrolling_map/game_levels_scrolling_map.dart';
import 'package:game_levels_scrolling_map/model/point_model.dart';
import 'dart:html' as html;

class Board extends BaseWidget {
  const Board({super.key});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _BoardState();
  }
}

class GamesLevel {
  final GameType type;
  int star;
  int score;
  bool isCompliated;

  GamesLevel(
      {required this.type,
      required this.star,
      required this.score,
      this.isCompliated = false});

  @override
  String toString() {
    return 'GamesLevel(type: $type, star: $star, score: $score, isCompliated: $isCompliated)';
  }
}

class _BoardState extends BaseWidgetState<Board> {
  List<int> indexToShow = [1, 3, 4, 7];
  GlobalKey boardViewKey = GlobalKey();
  List<GamesLevel> games = [
    GamesLevel(type: GameType.coffeeShop, star: 0, score: 0),
    GamesLevel(type: GameType.route, star: -1, score: 0),
    GamesLevel(type: GameType.house, star: -1, score: 0),
    GamesLevel(type: GameType.office, star: -1, score: 0),
  ];
  int index = 0;
  int totalScore = 0;
  bool showDownloadCertificat = false;

  @override
  void initState() {
    fillTestData();
    super.initState();
  }

  List<PointModel> points = [];

  void fillTestData() async {
    index = 0;
    points.clear();
    // rebuild();
    // await Future.delayed(const Duration(milliseconds: 300));
    for (int i = 0; i < 8; i++) {
      points.add(PointModel(100, testWidget(i)));
    }
    boardViewKey = GlobalKey();
    rebuild();
  }

  void calculateScore({required dynamic resp, required GameType gameType}) {
    int score = 0;
    bool isCompliated = true;
    int star = -1;
    if (resp != null) {
      score = int.parse(resp.toString());
    }

    if (score >= 90) {
      star = 3;
    } else if (score >= 70) {
      star = 2;
    } else if (score >= 50) {
      star = 1;
    } else {
      isCompliated = false;
      star = 0;
    }
    final g = games.firstWhere((element) => element.type == gameType);
    final index1 = games.indexOf(g);
    g.score = score;
    g.star = star;
    g.isCompliated = isCompliated;
    if (isCompliated && index1 < games.length - 1) {
      games[index1 + 1].star = 0;
    }

    /// calculate total score
    totalScore = games.fold(0, (previousValue, element) {
      return previousValue + element.score;
    });

    /// check if all games are compliated
    showDownloadCertificat =
        games.every((element) => element.isCompliated && element.star > 1);

    // rebuild
    fillTestData();

    print(games.toString());

    rebuild();
  }

  Widget testWidget(int order) {
    bool contains = indexToShow.contains(order);
    GamesLevel? g;
    if (contains) {
      index++;
      g = games[index - 1];
    }
    return contains
        ? InkWell(
            hoverColor: Colors.blue,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // CustomImageWidget(
                //   g!.image,
                //   directory: "assets/drawable",
                //   width: 100,

                //   // height: 100,
                //   fit: BoxFit.fitWidth,
                // ),
                // Image.asset(
                //   "assets/drawable/map_horizontal_point.png",
                //   fit: BoxFit.fitWidth,
                //   width: 100,
                // ),
                CustomContainer(
                  h: 80,
                  w: 80,
                  boxShape: BoxShape.circle,
                  gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(0, 240, 201, 1),
                        // Color.fromRGBO(100, 199, 193, 1),
                        Colors.green
                      ]),
                  padding: const EdgeInsets.only(top: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...List.generate(
                          (g!.star <= 0 ? 0 : g.star),
                          (index) => const CustomImageWidget(
                                "star",
                                directory: "assets/drawable",
                                width: 20,
                                height: 30,
                                fit: BoxFit.fitWidth,
                              )).toList()
                    ],
                  ),
                ),

                g.star == -1
                    ? const SizedBox.shrink()
                    : Text("$index",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 40)),
                g.star == -1
                    ? const CustomImageWidget(
                        "lock",
                        height: 40,
                        width: 40,
                        directory: "assets/drawable",
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            onTap: () async {
              if (g?.star == -1) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: const Text(
                          "S'il vous plaît, terminez le niveau précédent pour déverrouiller ce niveau"),
                      actions: <Widget>[
                        ElevatedButton(
                          child: const Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              } else {
                if (order == 1) {
                  final resp =
                      await toPage(const GamesView(type: GameType.coffeeShop));
                  calculateScore(resp: resp, gameType: GameType.coffeeShop);
                } else if (order == 4) {
                  final resp =
                      await toPage(const GamesView(type: GameType.route));
                  calculateScore(resp: resp, gameType: GameType.route);
                } else if (order == 3) {
                  final resp =
                      await toPage(const GamesView(type: GameType.house));
                  calculateScore(resp: resp, gameType: GameType.house);
                } else if (order == 7) {
                  final resp =
                      await toPage(const GamesView(type: GameType.office));
                  calculateScore(resp: resp, gameType: GameType.office);
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text("Point $order"),
                        actions: <Widget>[
                          ElevatedButton(
                            child: const Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              }
            },
          )
        : const SizedBox.shrink();
  }

  void downloadFile(String url) {
    html.AnchorElement anchorElement = html.AnchorElement(href: url);
    anchorElement.download = url;
    anchorElement.click();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: boardViewKey,
      body: LayoutBuilder(builder: (context, p1) {
        Size s = p1.biggest;
        return CustomContainer(
            h: s.height,
            w: s.width,
            color: Colors.white,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: GameLevelsScrollingMap.scrollable(
                    imageUrl: "assets/drawable/map_horizontal.png",
                    direction: Axis.horizontal,
                    svgUrl: 'assets/svg/map_horizontal.svg',
                    points: points,
                  ),
                ),
                Positioned(
                    top: 1.h,
                    right: 0.3.w,
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: CustomImageWidget(
                            "map_vertical_point",
                            directory: "assets/drawable",
                            width: 5.w,
                            // height: 5.w,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        // const SizedBox(height: 1),
                        CustomStrokeTextWidget(
                            "${Constant().nom} ${Constant().prenom}",
                            color: Colors.blue,
                            strokeColor: Colors.white,
                            size: 13.sp),
                        AnimatedDigitWidget(
                          value: totalScore,
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      ],
                    )),
                Align(
                  alignment: Alignment.center,
                  child: showDownloadCertificat
                      ? CustomContainer(
                          h: 70.h,
                          w: 30.w,
                          color: Colors.green.withOpacity(0.8),
                          child: Column(
                            children: [
                              CustomTextWidget(
                                "Félicitations !",
                                color: Colors.white,
                                size: 20.sp,
                              ),
                              SizedBox(height: 2.h),
                              CustomTextWidget(
                                "Vous avez terminé le jeu",
                                color: Colors.white,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                size: 16.sp,
                              ),
                              SizedBox(height: 10.h),
                              CustomTextWidget(
                                "Vous avez gagné un certificat d'écologie",
                                color: Colors.white,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                size: 16.sp,
                              ),
                              SizedBox(height: 13.h),
                              SizedBox(
                                height: 7.h,
                                width: 20.w,
                                child: ElevatedButton(
                                    onPressed: () {
                                      downloadFile(
                                          "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf");
                                      showDownloadCertificat = false;
                                    },
                                    child: CustomTextWidget(
                                      "Télécharger",
                                      color: Colors.green,
                                      size: 17.sp,
                                    )),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ));
      }),
    );
  }
}
