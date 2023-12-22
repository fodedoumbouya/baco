import 'dart:ui';

import 'package:baco/base/base.dart';
import 'package:baco/common/adapterHelper/responsive_sizer.dart';
import 'package:baco/pages/board.dart';
import 'package:baco/widgets/custom/custom.dart';
import 'package:baco/widgets/loading_view.dart';
import 'package:flutter/material.dart';

class Home extends BaseWidget {
  const Home({super.key});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _HomeState();
  }
}

class _HomeState extends BaseWidgetState<Home> {
  String prenom = "";
  String nom = "";
  Widget myTextField(
      {required String txt, required void Function(String) onChanged}) {
    return CustomContainer(
      w: 15.w,
      h: 5.h,
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: TextFormField(
        cursorColor: Colors.green,
        onChanged: onChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "$txt:",
          contentPadding: const EdgeInsets.only(left: 4),
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  register() async {
    // http://127.0.0.1:5000/define_user?name=testnom&firstname=prenom
    LoadingView(context: context).wrap(
      asyncFunction: () =>
          getMap("define_user?name=$nom&firstname=$prenom", (callback) {
        if (callback == "success") {
          jumpToPage(Board(prenom: prenom, nom: nom));
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text("Une erreur est survenue"),
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
      }, (o) {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (p0, p1) {
        Size s = p1.biggest;
        return CustomContainer(
          h: s.height,
          w: s.width,
          path: "assets/drawable",
          image: "home",
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    decoration:
                        BoxDecoration(color: Colors.white.withOpacity(0.0)),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomStrokeTextWidget(
                        "BIENVENUE SUR GAIA",
                        color: Colors.green,
                        strokeColor: Colors.white,
                        size: 25.sp,
                      ),
                      SizedBox(height: 5.h),
                      myTextField(
                        txt: "Prénom",
                        onChanged: (p0) {
                          prenom = p0;
                          rebuild();
                        },
                      ),
                      SizedBox(height: 1.h),
                      myTextField(
                        txt: "Nom",
                        onChanged: (p0) {
                          nom = p0;
                          rebuild();
                        },
                      ),
                      SizedBox(height: 5.h),
                      SizedBox(
                        width: 10.w,
                        height: 5.h,
                        child: ElevatedButton(
                            onPressed: () {
                              if (prenom.isNotEmpty && nom.isNotEmpty) {
                                // toPage(const Board());
                                register();
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: const Text(
                                          "Veuillez remplir les champs"),
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
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: (prenom.isEmpty || nom.isEmpty)
                                    ? Colors.green[100]
                                    : Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: const CustomTextWidget(
                              "Jouer",
                              color: Colors.white,
                            )),
                      )
                    ],
                  )),
            ],
          ),
        );
      }),
    );
  }
}
