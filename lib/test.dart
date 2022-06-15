import 'package:flutter/material.dart';
import 'package:qbix/components/app_components.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  PageState _pageState = PageState.LOADED;
  String _message = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    appLogs(Screens.TestScreen, tag: screenTag);
  }

  @override
  void dispose() {
    super.dispose();
  }

  _onLoad() {}

  _showLoading() {
    appLogs("TestScreen:_showLoading");
    setState(() => _pageState = PageState.LOADING);
  }

  _hideLoading() {
    appLogs("TestScreen:_hideLoading");
    setState(() => _pageState = PageState.LOADED);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.white,
      appBar: appBarCustom(title: "EVENT DETAILS"),
      body: Stack(
        children: <Widget>[
          getBody(),
          ScreenLoader(pageState: _pageState),
          AppErrorWidget(
            message: _message,
            pageState: _pageState,
            onTap: _onLoad,
          )
        ],
      ),
    );
  }

  Widget getBody() {
    return Placeholder();
  }
}
