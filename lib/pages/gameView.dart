import 'package:animated_digit/animated_digit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
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
  int energyOff = 0;
  bool displayExplication = false;

  List<Game> listGame = [];
  int index = 0;
  late bool isRoute;
  // HouseType oldHouseType = HouseType.bedroomDark;

  @override
  void initState() {
    super.initState();
    isRoute = widget.type == GameType.route;

    getData();
  }

  getData() {
    String path; //= isRoute ? "route" : "home";
    if (widget.type == GameType.route) {
      path = "route";
    } else if (widget.type == GameType.coffeeShop) {
      path = "coffee";
    } else if (widget.type == GameType.office) {
      path = "work";
    } else {
      path = "home";
    }
    getMap("game/$path", (callback) {
      // int i = 0;
      for (var game in callback) {
        // i++;
        // if (i <= 1) {
        //   listGame.add(Game.fromJson(game));
        // }
        listGame.add(Game.fromJson(game));
      }
      print("listGame:$listGame");
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
    print("type:$type houseType:$houseType");

    return houseType;
  }

  calculateScore() {
    Game game = listGame[index];
    if (isWrongIndex.isEmpty) {
      score += int.parse(game.score!);
    } else {
      if (game.reponse!.length > 1) {
        score += int.parse(game.score!) ~/ (isWrongIndex.length + 1);
      }
    }
    isRightIndex = [];
    isWrongIndex = [];
    // print("energyOff:$energyOff");
    rebuild();
  }

  calculateEnergy() {
    Game game = listGame[index];
    if (isWrongIndex.isEmpty) {
      energyOff = int.parse(game.energy!) ~/ 2;
    } else {
      energyOff = int.parse(game.energy!);
    }
    // rebuild();
  }

  void nextQuestion({int durationMinus = 0}) {
    Future.delayed(Duration(seconds: 1 - durationMinus), () {
      showDialog = false;
      rebuild();
    });

    Future.delayed(Duration(seconds: 2 - durationMinus), () {
      displayExplication = false;

      showDialog = true;
      allAnswer = false;
      calculateScore();

      if (index == listGame.length - 1) {
        allQuestionDone = true;
        showDialog = false;
      } else {
        index++;
      }
      rebuild();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget w;
    if (listGame.isEmpty) {
      w = const SizedBox.shrink();
    } else {
      if (isRoute) {
        w = RoutePage(
          chargeOff: energyOff,
          onChargeOff: () {
            energyOff = 0;
            // rebuild();
          },
        );
      } else {
        HouseType type;
        if (widget.type == GameType.house) {
          type = getHouseType(game: listGame[index]);
        } else if (widget.type == GameType.coffeeShop) {
          type = HouseType.coffeeShop;
        } else {
          type = HouseType.office;
        }
        w = House(type: type);
      }
    }
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        AwesomeDialog dlg = AwesomeDialog(
          context: context,
          dialogType: DialogType.question,
          animType: AnimType.bottomSlide,
          title: "Etes-vous sûr de vouloir quitter ?",
          desc: "Vous allez perdre votre progression",
          dismissOnTouchOutside: true,
          btnCancelOnPress: () {},
          btnOkOnPress: () => pop("0"),
          btnOkText: "Oui",
          btnCancelText: "Non",
          width: 40.w,
        );

        await dlg.show();
      },
      child: Scaffold(
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
                          child: w,
                          // const RoutePage(),

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
                                    pop(score.toString());
                                  },
                                  child: CompletView(
                                    score: score,
                                    isRoute: isRoute,
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
                          leftM: xx(p: (isRoute ? 15 : 10), s: s),
                          rightM: xx(p: 10, s: s),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withOpacity(0.7),
                              isRoute
                                  ? const Color.fromRGBO(91, 188, 146, 1)
                                  : Colors.red.withOpacity(0.7),
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
                                              displayExplication
                                                  ? '"${listGame[index].explication}"'
                                                  : '"${listGame[index].question}"',
                                              color: Colors.black,
                                              strokeColor: Colors.white,
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
                                        mainAxisAlignment: displayExplication
                                            ? MainAxisAlignment.center
                                            : MainAxisAlignment.spaceAround,
                                        children: [
                                          displayExplication
                                              ? AnswerBttn(
                                                  s: s,
                                                  text: "Suivant",
                                                  onTap: () {
                                                    nextQuestion(
                                                        durationMinus: 1);
                                                  })
                                              : const SizedBox.shrink(),
                                          ...List.generate(
                                              listGame[index]
                                                  .reponsesProposEs!
                                                  .length, (ind) {
                                            String answer = listGame[index]
                                                .reponsesProposEs![ind];
                                            return displayExplication
                                                ? const SizedBox.shrink()
                                                : AnswerBttn(
                                                    s: s,
                                                    text: answer,
                                                    isRight: isRightIndex
                                                        .contains(ind),
                                                    isWrong: isWrongIndex
                                                        .contains(ind),
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
                                                              isWrongIndex
                                                                  .length)) {
                                                        allAnswer = true;

                                                        if (isRoute) {
                                                          calculateEnergy();
                                                        }
                                                        if (isWrongIndex
                                                            .isNotEmpty) {
                                                          Future.delayed(
                                                              const Duration(
                                                                  seconds: 1),
                                                              () {
                                                            displayExplication =
                                                                true;
                                                            rebuild();
                                                          });
                                                        } else {
                                                          nextQuestion();
                                                        }
                                                      }
                                                      rebuild();
                                                    },
                                                  );
                                          }),
                                        ]

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

                      Positioned(
                          top: 1.h,
                          right: 0.3.w,
                          child: AnimatedDigitWidget(
                            value: score,
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            duration: const Duration(seconds: 1),
                          ))
                    ],
                  ),
                );
        }),
      ),
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
  final bool isRoute;
  const CompletView({required this.score, required this.isRoute, super.key});

  @override
  Widget build(BuildContext context) {
    Color color = isRoute ? Colors.red : Colors.green;
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
              color: color,
              fontWeight: FontWeight.bold,
              strokeColor: Colors.white,
              size: 20.sp,
            ),
            SizedBox(
              height: 2 * (s.height / 100),
            ),
            CustomStrokeTextWidget(
              "SCORE: $score/100",
              color: color,
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
