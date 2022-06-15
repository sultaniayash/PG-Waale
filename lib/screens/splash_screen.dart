import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:qbix/services/a_services.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';
import 'package:qbix/widgets/background_widget.dart';
import 'package:qbix/widgets/logo_widget.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with AfterLayoutMixin<SplashScreen> {
  PageState _pageState = PageState.LOADING;

  Future<Null> redirectUser() async {
    _showLoading();
    await auth.setUserFromSharedPreference();
    StatusBarService.changeStatusColor(
      Colors.transparent,
      whiteForeground: false,
    );

    await Auth.redirectUserAsPerStatus(context);
  }

  @override
  void initState() {
    super.initState();
    appLogs(Screens.SplashScreen, tag: "Screen");
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    /* --------initScreenAwareConstant-----------   */
    Sizes.initScreenAwareConstant(context);
    /* --------initScreenAwareConstant-----------   */
    Future.delayed(Duration(milliseconds: Constants.delayLarge), redirectUser);
  }

  _showLoading() {
    appLogs("LoginScreen:_showLoading");
    if (mounted) setState(() => _pageState = PageState.LOADING);
  }

  _hideLoading() {
    appLogs("LoginScreen:_hideLoading");
    if (mounted) setState(() => _pageState = PageState.LOADED);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: <Widget>[
          BackgroundWidget(),
          BackgroundOverlayWidget(),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Sizes.s20,
              vertical: Sizes.s100,
            ),
            child: AppLogoWidget(),
          ),
          ScreenLoader(pageState: _pageState),
        ],
      ),
    );
  }
}
