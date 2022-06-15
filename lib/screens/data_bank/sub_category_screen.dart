import 'package:after_layout/after_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:firestore_ui/firestore_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qbix/components/app_components.dart';
import 'package:qbix/models/category_model.dart';
import 'package:qbix/models/register_models.dart';
import 'package:qbix/models/sub_category_model.dart';
import 'package:qbix/screens/data_bank/document_screen.dart';
import 'package:qbix/services/a_services.dart';
import 'package:qbix/services/firebase_service.dart';
import 'package:qbix/theme/app_colors.dart';
import 'package:qbix/utils/a_utils.dart';
import 'package:qbix/widgets/empty_widget.dart';

import 'data_bank_widgets.dart';

class SubCategoryScreen extends StatefulWidget {
  final AppCountry appCountry;
  final CategoryDataBank categoryDataBank;

  const SubCategoryScreen({
    Key key,
    @required this.appCountry,
    @required this.categoryDataBank,
  }) : super(key: key);

  @override
  _SubCategoryScreenState createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> with AfterLayoutMixin<SubCategoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageState _pageState = PageState.LOADING;
  String _message = "";

  @override
  void initState() {
    super.initState();
    appLogs(Screens.SubCategoryScreen, tag: screenTag);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    onLoad();
  }

  onLoad() async {
    appLogs("SubCategoryScreen:onLoad");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.white,
      appBar: appBarCustom(title: Strings.subCategories),
      body: Stack(
        children: <Widget>[
          getBody(),
          ScreenLoader(pageState: _pageState),
          AppErrorWidget(
            message: _message,
            pageState: _pageState,
            onTap: onLoad,
          )
        ],
      ),
    );
  }

  Widget getBody() {
    return Column(
      children: <Widget>[
        TopBar(
          title: widget.appCountry.name + Strings.splitter + widget.categoryDataBank.name,
        ),
        Flexible(
          child: FirestoreAnimatedList(
            padding: EdgeInsets.symmetric(horizontal: Sizes.s30, vertical: Sizes.s10),
            query: FirebaseRepo.getDataBankSubCategory(widget.appCountry.iso3Code, widget.categoryDataBank.id),
            itemBuilder: (BuildContext context, DocumentSnapshot snapshot, Animation animation, int index) {
              SubCategoryDataBank subCategoryDataBank = SubCategoryDataBank.fromMap(
                id: snapshot.documentID,
                data: snapshot.data,
              );
              return SubCategoryDataBankWidget(
                subCategoryDataBank: subCategoryDataBank,
                onTap: () {
                  AppRoutes.push(
                      context,
                      DocumentScreen(
                        appCountry: widget.appCountry,
                        categoryDataBank: widget.categoryDataBank,
                        subCategoryDataBank: subCategoryDataBank,
                      ));
                },
              );
            },
            emptyChild: EmptyWidget(message: Strings.noCategories),
            errorChild: EmptyWidget(message: AlertTitle.error.toUpperCase()),
            onLoaded: (_) {
              _hideLoading();
            },
          ),
        ),
      ],
    );
  }

  _showLoading() {
    appLogs("SubCategoryScreen:_showLoading");
    setState(() => _pageState = PageState.LOADING);
  }

  _hideLoading() {
    appLogs("SubCategoryScreen:_hideLoading");
    setState(() => _pageState = PageState.LOADED);
  }

  _showError() {
    appLogs("SubCategoryScreen:_showError");
    setState(() => _pageState = PageState.ERROR);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
