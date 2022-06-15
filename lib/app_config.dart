import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:qbix/utils/a_utils.dart';

class App {
  static final int versionCode = 2;
  static final String versionName = '0.0.2';
  static final String appName = 'Qbix';
  static final String androidURL = "https://play.google.com/store/apps/details?id=com.virtoustack.qbix";
  static final String iosURL = "https://apps.apple.com/in/app/qbix/id";
  static bool devMode = false;
  static bool appLog = false;
  static bool apiLog = false;
}

class AppConfigurations {
  final bool appLog;
  final bool apiLog;
  final bool devMode;

  AppConfigurations({
    @required this.appLog,
    @required this.apiLog,
    @required this.devMode,
  });

  initApp() {
    /* --------Setting Screen Orientation Portrait-----------   */
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    /* --------Setting Screen Orientation Portrait-----------   */

    App.devMode = this.devMode;
    App.appLog = this.appLog;
    App.apiLog = this.apiLog;

    appLogs('''
    ======AppConfigurations======
        App.appName : ${App.appName}
        App.versionCode : ${App.versionCode}
        App.versionName : ${App.versionName} 
        App.appLog : ${App.appLog}
        App.apiLog : ${App.apiLog}
        App.devMode : ${App.devMode}
           ''');
  }
}
