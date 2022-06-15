import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qbix/utils/a_utils.dart';

class AppRoutes {
  static bool loaderShowing = false;

  static void showLoader(context, {bool barrierDismissible = true, WillPopCallback onWillPop}) {
    loaderShowing = true;
    appLogs('showLoader $loaderShowing');
    showDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (_) {
          return WillPopScope(
            onWillPop: onWillPop ??
                () async {
                  return false;
                },
            child: FullScreenLoader(),
          );
        });
  }

  static void dismissLoader(context) {
    appLogs('dismissLoader $loaderShowing');
    if (loaderShowing) {
      loaderShowing = false;
      Navigator.of(context).pop();
    }
  }

  static void push(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      new CupertinoPageRoute(builder: (context) => screen),
    );
  }

  static void replace(BuildContext context, Widget screen) {
    Navigator.of(context).pushReplacement(
      new CupertinoPageRoute(builder: (context) => screen),
    );
  }

  static void makeFirst(BuildContext context, Widget screen) {
    Navigator.of(context).popUntil((predicate) => predicate.isFirst);
    Navigator.of(context).pushReplacement(
      new CupertinoPageRoute(builder: (context) => screen),
    );
  }

  static void pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void mayBePop(BuildContext context) {
    Navigator.of(context).maybePop();
  }

  static void dismissAlert(context) {
    Navigator.of(context).pop();
  }
}
