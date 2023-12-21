import 'dart:async';

import 'package:baco/common/myLog.dart';
import 'package:baco/pages/root.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/config.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (kDebugMode || kProfileMode) {
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack!);
    }
  };

  runZonedGuarded(
    () {
      Config.init(() => runApp(const ProviderScope(child: Root())));
    },
    (Object error, StackTrace stackTrace) {
      AppLog.e("Error FROM OUT_SIDE FRAMEWORK ");
      AppLog.e("--------------------------------");
      AppLog.i("Error :  $error");
      AppLog.e("StackTrace :  $stackTrace");

      // _reportError(error, stackTrace);
    },
  );
}
