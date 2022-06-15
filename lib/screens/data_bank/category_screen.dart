import 'package:after_layout/after_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:firestore_ui/firestore_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qbix/components/app_components.dart';
import 'package:qbix/models/category_model.dart';
import 'package:qbix/models/register_models.dart';
import 'package:qbix/screens/data_bank/sub_category_screen.dart';
import 'package:qbix/services/a_services.dart';
import 'package:qbix/services/firebase_service.dart';
import 'package:qbix/theme/app_colors.dart';
import 'package:qbix/utils/a_utils.dart';
import 'package:qbix/widgets/empty_widget.dart';

import 'data_bank_widgets.dart';

class CategoryScreen extends StatefulWidget {
  final AppCountry appCountry;

  const CategoryScreen({Key key, @required this.appCountry}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with AfterLayoutMixin<CategoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageState _pageState = PageState.LOADING;
  String _message = "";

  @override
  void initState() {
    super.initState();
    appLogs(Screens.CategoryScreen, tag: screenTag);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _onLoad();
  }

  _onLoad() async {
    appLogs("CategoryScreen:_onLoad");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.white,
      appBar: appBarCustom(
        title: Strings.categories,
      ),
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
    return Column(
      children: <Widget>[
        TopBar(
          title: widget.appCountry.name,
        ),
        Flexible(
          child: FirestoreAnimatedList(
            padding: EdgeInsets.symmetric(horizontal: Sizes.s30, vertical: Sizes.s10),
            query: FirebaseRepo.getDataBankCategory(widget.appCountry.iso3Code),
            itemBuilder: (BuildContext context, DocumentSnapshot snapshot, Animation animation, int index) {
              CategoryDataBank categoryDataBank = CategoryDataBank.fromMap(
                id: snapshot.documentID,
                data: snapshot.data,
              );
              return CategoryDataBankWidget(
                categoryDataBank: categoryDataBank,
                onTap: () {
                  AppRoutes.push(
                      context,
                      SubCategoryScreen(
                        appCountry: widget.appCountry,
                        categoryDataBank: categoryDataBank,
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
    appLogs("CategoryScreen:_showLoading");
    setState(() => _pageState = PageState.LOADING);
  }

  _hideLoading() {
    appLogs("CategoryScreen:_hideLoading");
    setState(() => _pageState = PageState.LOADED);
  }

  _showError() {
    appLogs("CategoryScreen:_showError");
    setState(() => _pageState = PageState.ERROR);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
