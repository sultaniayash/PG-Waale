import 'package:flutter/material.dart';
import 'package:qbix/components/app_components.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';
import 'package:qbix/widgets/empty_widget.dart';

class QueriesScreen extends StatefulWidget {
  @override
  _QueriesScreenState createState() => _QueriesScreenState();
}

class _QueriesScreenState extends State<QueriesScreen> {
  PageState _pageState = PageState.LOADED;
  String _message = "";

  @override
  void initState() {
    super.initState();
    appLogs(Screens.QueriesScreen, tag: screenTag);
  }

  @override
  void dispose() {
    super.dispose();
  }

  _showLoading() {
    appLogs("QueriesScreen:_showLoading");
    setState(() => _pageState = PageState.LOADING);
  }

  _hideLoading() {
    appLogs("QueriesScreen:_hideLoading");
    setState(() => _pageState = PageState.LOADED);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: appBarCustom(
        title: 'Queries',
      ),
      body: EmptyWidget(message: "No Queries!"),
    );
  }
}
