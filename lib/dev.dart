import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:qbix/screens/splash_screen.dart';
import 'package:qbix/services/auth_service.dart';
import 'package:qbix/services/firebase_service.dart';
import 'package:qbix/theme/app_theme.dart';

import 'app_config.dart';
import 'services/a_services.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  StatusBarService.changeStatusColor(
    Colors.transparent,
    whiteForeground: false,
  );

  /* --------Firebase-----------*/
  firestore = Firestore(app: await initFirebaseApp());
  /* --------Firebase-----------*/
  await auth.setUserFromSharedPreference();

  AppConfigurations(
    devMode: true,
    appLog: true,
    apiLog: true,
  )..initApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConnectivityAppWrapper(
      app: MaterialApp(
        title: App.appName,
        debugShowCheckedModeBanner: true,
        home: SplashScreen(),
        theme: themeData,
      ),
    );
  }
}
