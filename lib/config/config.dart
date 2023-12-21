import 'package:baco/common/network/network.dart';
import 'package:flutter/widgets.dart';

class Config {
  static Future init(Function() runApp) async {
    WidgetsFlutterBinding.ensureInitialized();

    DioUtil.init();

    runApp();
  }
}
