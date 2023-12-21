import 'dart:developer';

import 'package:flutter/material.dart';

/// A Logger For Flutter Apps
/// Usage:
/// 1) AppLog.i("Info Message");
/// 2) AppLog.i("Home Page", tag: "User Logging");
class AppLog {
  static const String _DEFAULT_TAG_PREFIX = "portofoliosApp";

  ///use Log.v. Print all Logs
  static const int VERBOSE = 2;

  ///use Log.d. Print Debug Logs
  static const int DEBUG = 3;

  ///use Log.i. Print Info Logs
  static const int INFO = 4;

  ///use Log.w. Print warning logs
  static const int WARN = 5;

  ///use Log.e. Print error logs
  static const int ERROR = 6;

  ///use Log.wtf. Print Failure Logs(What a Terrible Failure= WTF)
  static const int WTF = 7;

  ///SET APP LOG LEVEL, Default ALL
  static int _currentLogLevel = VERBOSE;

  static setLogLevel(int priority) {
    int newPriority = priority;
    if (newPriority <= VERBOSE) {
      newPriority = VERBOSE;
    } else if (newPriority >= WTF) {
      newPriority = WTF;
    }
    _currentLogLevel = newPriority;
  }

  static int getLogLevel() {
    AppLog.i("Current Log Level is ${_getPriorityText(_currentLogLevel)}");
    return _currentLogLevel;
  }

  static _log(int priority, String tag, String message, {bool isLog = false}) {
    if (_currentLogLevel <= priority) {
      if (isLog) {
        log("${_getPriorityText(priority)}$tag: $message");
      } else {
        debugPrint("${_getPriorityText(priority)}$tag: $message");
      }
    }
  }

  static String _getPriorityText(int priority) {
    switch (priority) {
      case INFO:
        return "INFO 🔦 🔦 🔦 | ";
      case DEBUG:
        return "DEBUG 🛠️ 🛠️ 🛠️ | ";
      case ERROR:
        return "ERROR 🚨 🚨 🚨 | ";
      case WARN:
        return "WARN 🪤 🪤 🪤 | ";
      case WTF:
        return "WTF 🧨 ⚔  ️🩻 ⚰ 🪦 | ";
      case VERBOSE:
        return "VERIFICATION 🎧 🎧 🎧 | ";
      default:
        return "";
    }
  }

  ///Print general logs
  static v(String message, {String tag = _DEFAULT_TAG_PREFIX}) {
    _log(VERBOSE, tag, message, isLog: true);
  }

  ///Print info logs
  static i(String message, {String tag = _DEFAULT_TAG_PREFIX}) {
    _log(INFO, tag, message);
  }

  ///Print debug logs
  static d(String message, {String tag = _DEFAULT_TAG_PREFIX}) {
    _log(DEBUG, tag,
        "═════════════════════════════════════════════════════════════\n╔╣$message╠╗\n ══════════════════════════════════════════════════════════════════════════════════════════╝");
  }

  ///Print warning logs
  static w(String message, {String tag = _DEFAULT_TAG_PREFIX}) {
    _log(WARN, tag, message, isLog: true);
  }

  ///Print error logs
  static e(String message, {String tag = _DEFAULT_TAG_PREFIX}) {
    _log(ERROR, tag, message, isLog: true);
  }

  ///Print failure logs
  static wtf(String message, {String tag = _DEFAULT_TAG_PREFIX}) {
    _log(WTF, tag, message, isLog: true);
  }
}
