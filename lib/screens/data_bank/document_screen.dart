import 'package:after_layout/after_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/firestore_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qbix/components/app_components.dart';
import 'package:qbix/models/category_model.dart';
import 'package:qbix/models/documents_model.dart';
import 'package:qbix/models/register_models.dart';
import 'package:qbix/models/sub_category_model.dart';
import 'package:qbix/screens/data_bank/view_document_screen.dart';
import 'package:qbix/services/a_services.dart';
import 'package:qbix/services/firebase_service.dart';
import 'package:qbix/theme/app_colors.dart';
import 'package:qbix/theme/textstyles.dart';
import 'package:qbix/utils/a_utils.dart';
import 'package:qbix/widgets/empty_widget.dart';

import 'data_bank_widgets.dart';

class DocumentScreen extends StatefulWidget {
  final AppCountry appCountry;
  final CategoryDataBank categoryDataBank;
  final SubCategoryDataBank subCategoryDataBank;

  const DocumentScreen({
    Key key,
    @required this.appCountry,
    @required this.categoryDataBank,
    @required this.subCategoryDataBank,
  }) : super(key: key);

  @override
  _DocumentScreenState createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> with AfterLayoutMixin<DocumentScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageState _pageState = PageState.LOADED;
  String _message = "";

  @override
  void initState() {
    super.initState();
    appLogs(Screens.DocumentScreen, tag: screenTag);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _onLoad();
  }

  _onLoad() async {
    appLogs("DocumentScreen:_onLoad");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.white,
      appBar: appBarCustom(title: Strings.documents.toUpperCase()),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TopBar(
          title: widget.appCountry.name +
              Strings.splitter +
              widget.categoryDataBank.name +
              Strings.splitter +
              widget.subCategoryDataBank.name,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: Sizes.s30, vertical: Sizes.s10),
          child: Text(
            Strings.videos,
            style: TextStyles.defaultSemiBold,
            textAlign: TextAlign.left,
          ),
        ),
        Flexible(
          child: FirestoreAnimatedGrid(
            padding: EdgeInsets.symmetric(horizontal: Sizes.s30, vertical: Sizes.s10),
            query: FirebaseRepo.getDataBankDocumentByType(
              widget.appCountry.iso3Code,
              widget.categoryDataBank.id,
              widget.subCategoryDataBank.id,
              fileType: AppFileType.VIDEO,
            ),
            itemBuilder: (BuildContext context, DocumentSnapshot snapshot, Animation animation, int index) {
              AppDocument appDocument = AppDocument.fromMap(
                id: snapshot.documentID,
                data: snapshot.data,
              );
              return DocumentWidget(
                appDocument: appDocument,
                onTap: () async {
                  AppRoutes.push(context, ViewDocumentScreen(appDocument: appDocument));
                },
              );
            },
            emptyChild: EmptyWidget(message: Strings.noVideos),
            errorChild: EmptyWidget(message: AlertTitle.error.toUpperCase()),
            crossAxisCount: 2,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: Sizes.s30, vertical: Sizes.s10),
          child: Text(
            Strings.documents,
            style: TextStyles.defaultSemiBold,
            textAlign: TextAlign.left,
          ),
        ),
        Flexible(
          child: FirestoreAnimatedGrid(
            padding: EdgeInsets.symmetric(horizontal: Sizes.s30, vertical: Sizes.s10),
            query: FirebaseRepo.getDataBankDocumentByType(
              widget.appCountry.iso3Code,
              widget.categoryDataBank.id,
              widget.subCategoryDataBank.id,
            ),
            itemBuilder: (BuildContext context, DocumentSnapshot snapshot, Animation animation, int index) {
              AppDocument appDocument = AppDocument.fromMap(
                id: snapshot.documentID,
                data: snapshot.data,
              );
              return DocumentWidget(
                appDocument: appDocument,
                size: Sizes.s40,
                onTap: () async {
                  AppRoutes.push(context, ViewDocumentScreen(appDocument: appDocument));
                },
              );
            },
            emptyChild: EmptyWidget(message: Strings.noDocuments),
            errorChild: EmptyWidget(message: AlertTitle.error.toUpperCase()),
            crossAxisCount: 3,
          ),
        ),
      ],
    );
  }

  _showLoading() {
    appLogs("DocumentScreen:_showLoading");
    setState(() => _pageState = PageState.LOADING);
  }

  _hideLoading() {
    appLogs("DocumentScreen:_hideLoading");
    setState(() => _pageState = PageState.LOADED);
  }

  _showError() {
    appLogs("DocumentScreen:_showError");
    setState(() => _pageState = PageState.ERROR);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
