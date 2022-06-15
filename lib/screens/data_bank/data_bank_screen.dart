import 'package:after_layout/after_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/firestore_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qbix/components/app_components.dart';
import 'package:qbix/models/register_models.dart';
import 'package:qbix/services/a_services.dart';
import 'package:qbix/services/firebase_service.dart';
import 'package:qbix/theme/app_colors.dart';
import 'package:qbix/utils/a_utils.dart';
import 'package:qbix/widgets/empty_widget.dart';

import 'category_screen.dart';
import 'data_bank_widgets.dart';

class DataBankScreen extends StatefulWidget {
  @override
  _DataBankScreenState createState() => _DataBankScreenState();
}

class _DataBankScreenState extends State<DataBankScreen> with AfterLayoutMixin<DataBankScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageState _pageState = PageState.LOADING;
  String _message = "";

  @override
  void initState() {
    super.initState();
    appLogs(Screens.DataBankScreen, tag: screenTag);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _onLoad();
  }

  _onLoad() async {
    appLogs("DataBankScreen:_onLoad");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.white,
      appBar: appBarCustom(title: Strings.dataBank),
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
    return FirestoreAnimatedGrid(
      padding: EdgeInsets.symmetric(horizontal: Sizes.s30, vertical: Sizes.s10),
      query: FirebaseRepo.getDataBanks(),
      itemBuilder: (BuildContext context, DocumentSnapshot snapshot, Animation animation, int index) {
        AppCountry appCountry = AppCountry.fromMap(snapshot.data);
        return CountryWidget(
          appCountry: appCountry,
          onTap: () {
            AppRoutes.push(context, CategoryScreen(appCountry: appCountry));
          },
        );
      },
      emptyChild: EmptyWidget(message: Strings.noCountries),
      errorChild: EmptyWidget(message: AlertTitle.error.toUpperCase()),
      crossAxisCount: 2,
      onLoaded: (_) => _hideLoading(),
    );
  }

  _showLoading() {
    appLogs("DataBankScreen:_showLoading");
    setState(() => _pageState = PageState.LOADING);
  }

  _hideLoading() {
    appLogs("DataBankScreen:_hideLoading");
    setState(() => _pageState = PageState.LOADED);
  }

  _showError() {
    appLogs("DataBankScreen:_showError");
    setState(() => _pageState = PageState.ERROR);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
