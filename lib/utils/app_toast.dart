import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qbix/theme/app_colors.dart';

class AppToast {
  static Future<Null> showMessage(String message, {Color backgroundColor, ToastGravity toastGravity}) async {
    await Fluttertoast.showToast(
      msg: "$message",
      toastLength: Toast.LENGTH_SHORT,
      gravity: toastGravity ?? ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: backgroundColor ?? AppColors.primary,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
