import 'package:baco/common/adapterHelper/responsive_sizer.dart';
import 'package:baco/models/enum.dart';
import 'package:baco/pages/gameView.dart';
import 'package:baco/pages/board.dart';
import 'package:baco/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        title: "Baco",
        debugShowCheckedModeBanner: false,
        home: const Home(),
        // const GamesView(type: GameType.route),
        // const Board(),
        builder: EasyLoading.init(),
      );
    });
  }
}
