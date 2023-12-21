import 'package:baco/base/base.dart';
import 'package:baco/common/adapterHelper/responsive_sizer.dart';
import 'package:baco/common/myLog.dart';
import 'package:baco/models/enum.dart';
import 'package:baco/models/game.dart';
import 'package:baco/pages/games/route.dart';
import 'package:baco/widgets/custom/custom.dart';
import 'package:baco/widgets/custom/customContenair.dart';
import 'package:baco/widgets/custom/customTextWidget.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'games/house.dart';

class GamesView extends BaseWidget {
  final GameType type;
  const GamesView({required this.type, super.key});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _GamesViewState();
  }
}

class _GamesViewState extends BaseWidgetState<GamesView> {
  bool showDialog = true;
  bool allAnswer = false;
  List<int> isRightIndex = [];
  List<int> isWrongIndex = [];
  int isTapndex = -1;
  bool allQuestionDone = false;
  int score = 0;

  bool isChangingRoom = false;
  List<Game> listGame = [];
  int index = 0;
  // HouseType oldHouseType = HouseType.bedroomDark;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() {
    getMap("game/home", (callback) {
      int i = 0;
      for (var game in callback) {
        i++;
        if (i <= 1) {
          listGame.add(Game.fromJson(game));
        }
        // listGame.add(Game.fromJson(game));
      }
      rebuild();
    }, (o) {});
  }

  HouseType getHouseType({required Game game}) {
    List<String> type = game.motCles ?? [];
    HouseType houseType = HouseType.bedroomDark;
    if (type.contains("Bedroom")) {
      houseType = HouseType.bedroomDark;
    } else if (type.contains("Bathroom")) {
      houseType = HouseType.bathroom;
    } else if (type.contains("Kitchen")) {
      houseType = HouseType.kitchen;
    } else if (type.contains("Garrage")) {
      houseType = HouseType.garrage;
    } else if (type.contains("LivingRoom")) {
      houseType = HouseType.livingRoomDark;
    }
    // print("type:$type houseType:$houseType");

    return houseType;
  }

  calculateScore() {
    Game game = listGame[index];
    if (isWrongIndex.isEmpty) {
      score += int.parse(game.score!);
    } else {
      score += int.parse(game.score!) ~/ (isWrongIndex.length + 1);
    }
    isRightIndex = [];
    isWrongIndex = [];
    rebuild();
    // print("score:$score");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (p0, p1) {
        Size s = p1.biggest;
        return listGame.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : CustomContainer(
                h: s.height,
                w: s.width,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        height: s.height,
                        width: s.width,
                        child: const RoutePage(),

                        // House(
                        //   type: getHouseType(game: listGame[index]),
                        // ),
                      ),
                    ),
                    // level completed
                    Align(
                        alignment: Alignment.center,
                        child: allQuestionDone
                            ? TapRegion(
                                onTapInside: (event) {
                                  pop();
                                },
                                child: CompletView(
                                  score: score,
                                ))
                            : const SizedBox.shrink()),

                    AnimatedPositioned(
                      duration: const Duration(seconds: 1),
                      bottom: showDialog ? 0 : -yy(p: 40, s: s),
                      left: 0,
                      right: 0,
                      child: CustomContainer(
                        h: yy(p: 20, s: s),
                        // w: xx(p: 50, s: s),
                        leftM: xx(p: 10, s: s),
                        rightM: xx(p: 10, s: s),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.7),
                            Colors.red.withOpacity(0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        child: Column(
                          children: [
                            Flexible(
                                flex: 2,
                                child: CustomContainer(
                                    color: Colors.transparent,
                                    alig: Alignment.center,
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: CustomStrokeTextWidget(
                                            '"${listGame[index].question}"',
                                            color: Colors.white,
                                            strokeColor: Colors.black,
                                            size: 15.sp,
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: CustomStrokeTextWidget(
                                            "${index + 1} / ${listGame.length}",
                                            strokeColor: Colors.black,
                                            size: 14.sp,
                                          ),
                                        ),
                                      ],
                                    ))),
                            Flexible(
                                flex: 1,
                                child: CustomContainer(
                                  color: Colors.transparent,
                                  alig: Alignment.center,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: List.generate(
                                          listGame[index]
                                              .reponsesProposEs!
                                              .length, (ind) {
                                        String answer = listGame[index]
                                            .reponsesProposEs![ind];
                                        return AnswerBttn(
                                          s: s,
                                          text: answer,
                                          isRight: isRightIndex.contains(ind),
                                          isWrong: isWrongIndex.contains(ind),
                                          allAnswer: allAnswer,
                                          onTap: () {
                                            if (listGame[index]
                                                .reponse!
                                                .contains(ind)) {
                                              isRightIndex.add(ind);
                                            } else {
                                              isWrongIndex.add(ind);
                                            }
                                            if (listGame[index]
                                                    .reponse!
                                                    .length ==
                                                (isRightIndex.length +
                                                    isWrongIndex.length)) {
                                              allAnswer = true;

                                              Future.delayed(
                                                  const Duration(seconds: 1),
                                                  () {
                                                showDialog = false;
                                                rebuild();
                                              });

                                              Future.delayed(
                                                  const Duration(seconds: 2),
                                                  () {
                                                showDialog = true;
                                                allAnswer = false;
                                                calculateScore();

                                                if (index ==
                                                    listGame.length - 1) {
                                                  allQuestionDone = true;
                                                  showDialog = false;
                                                } else {
                                                  index++;
                                                }
                                                rebuild();
                                              });
                                            }
                                            rebuild();
                                          },
                                        );
                                      })

                                      // [
                                      //   AnswerBttn(
                                      //     s: s,
                                      //     text: "Quest 1",
                                      //     isRight: questTap == "Quest 1",
                                      //     allAnswer: allAnswer,
                                      //     onTap: () {
                                      //       questTap = "Quest 1";
                                      //       allAnswer = true;
                                      //       setState(() {});
                                      //       Future.delayed(
                                      //           const Duration(seconds: 1), () {
                                      //         showDialog = false;
                                      //         setState(() {});
                                      //       });

                                      //       Future.delayed(
                                      //           const Duration(seconds: 2), () {
                                      //         setState(() {
                                      //           showDialog = true;
                                      //           allAnswer = false;
                                      //           questTap = "";
                                      //         });
                                      //       });
                                      //     },
                                      //   ),
                                      //   AnswerBttn(
                                      //     s: s,
                                      //     text: "Quest 2",
                                      //     allAnswer: allAnswer,
                                      //     onTap: () {},
                                      //   ),
                                      //   AnswerBttn(
                                      //     s: s,
                                      //     text: "Quest 1",
                                      //     allAnswer: allAnswer,
                                      //     onTap: () {},
                                      //   ),
                                      //   AnswerBttn(
                                      //     s: s,
                                      //     text: "Quest 2",
                                      //     allAnswer: allAnswer,
                                      //     onTap: () {},
                                      //   ),
                                      // ],

                                      ),
                                )),
                          ],
                        ),
                      ),
                    ),

                    // AnimatedPositioned(
                    //     left: isChangingRoom ? s.width : -s.width,
                    //     duration: const Duration(seconds: 2),
                    //     child: CustomContainer(
                    //       h: s.height,
                    //       w: s.width,
                    //       color: Colors.black,
                    //     ))
                  ],
                ),
              );
      }),
    );
  }
}

class AnswerBttn extends StatelessWidget {
  final Size s;
  final void Function() onTap;
  final String text;
  final bool isRight, isWrong, allAnswer;
  const AnswerBttn(
      {required this.s,
      required this.text,
      this.isRight = false,
      this.isWrong = false,
      this.allAnswer = false,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    Color color = Colors.white;
    Color borderColor = Colors.black;
    if (isRight) {
      color = Colors.green;
      borderColor = Colors.white;
    } else if (isWrong) {
      color = Colors.red;
      borderColor = Colors.white;
    } else if (allAnswer) {
      color = Colors.grey;
      borderColor = Colors.black;
    }
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: CustomContainer(
          color: color,
          h: 5 * s.height / 100,
          w: 18 * s.width / 100,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: borderColor.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
          alig: Alignment.center,
          child: CustomTextWidget(
            text,
            color: borderColor,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class CompletView extends StatelessWidget {
  final int score;
  const CompletView({required this.score, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, p1) {
      Size s = p1.biggest;
      return CustomContainer(
        h: s.height,
        w: s.width,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomStrokeTextWidget(
              "LEVEL COMPLETED",
              color: Colors.green,
              fontWeight: FontWeight.bold,
              strokeColor: Colors.white,
              size: 20.sp,
            ),
            SizedBox(
              height: 2 * (s.height / 100),
            ),
            CustomStrokeTextWidget(
              "SCORE: $score/100",
              color: Colors.green,
              fontWeight: FontWeight.bold,
              strokeColor: Colors.white,
              size: 20.sp,
            ),
            SizedBox(
              height: 5 * (s.height / 100),
            ),
            CustomContainer(
              h: 10 * (s.height / 100),
              w: s.width,
              color: Colors.black,
              alig: Alignment.center,
              child: CustomTextWidget("PESS ANYWHERE TO CONTINUE",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  size: 18.sp),
            ),
          ],
        ),
      );
    });
  }
}

// class AnswerButtn extends StatelessWidget {
//   final String answer;
//   final double h;
//   final double w;
//   final bool allAnswer;
//   final bool isRight;
//   final bool isWrong;
//   final void Function() onTap;
//   const AnswerButtn(
//       {required this.answer,
//       required this.h,
//       required this.w,
//       required this.onTap,
//       this.allAnswer = false,
//       this.isRight = false,
//       this.isWrong = false,
//       super.key});

//   @override
//   Widget build(BuildContext context) {
//     Color color = Colors.white;
//     if (allAnswer) {
//       color = Colors.grey;
//     } else if (isRight) {
//       color = Colors.green;
//     } else if (isWrong) {
//       color = Colors.red;
//     }
//     return InkWell(
//       onTap: onTap,
//       child: MouseRegion(
//         cursor: SystemMouseCursors.click,
//         onEnter: (o) {
//           // onMouseOn = true;
//           // mySetState;
//         },
//         onExit: (o) {
//           // onMouseOn = false;
//           // mySetState;
//         },
//         child: CustomContainer(
//           h: h,
//           w: w,
//           color: color,
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.5),
//               spreadRadius: 1,
//               blurRadius: 1,
//               offset: const Offset(0, 1), // changes position of shadow
//             ),
//           ],
//           child: Center(
//             child: CustomTextWidget(
//               answer,
//               color: Colors.black,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
