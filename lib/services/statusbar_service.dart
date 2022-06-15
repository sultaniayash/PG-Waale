import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:qbix/utils/a_utils.dart';

class StatusBarService {
  static Future<Null> hideStatusBar() async {
    await Future.delayed(Duration(milliseconds: Constants.delayMedium));
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  }

  static Future<Null> showStatusBar() async {
    await Future.delayed(Duration(milliseconds: Constants.delayMedium));
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  static Future<Null> changeStatusColor(Color color, {bool whiteForeground = true}) async {
    try {
      await FlutterStatusbarcolor.setStatusBarColor(color, animate: true);
      await Future.delayed(Duration(milliseconds: Constants.delayMedium));
      await FlutterStatusbarcolor.setStatusBarWhiteForeground(whiteForeground);
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  static void resetStatusBarColor() {
    SystemChrome.restoreSystemUIOverlays();
  }
}
