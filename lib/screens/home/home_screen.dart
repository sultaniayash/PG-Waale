import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qbix/components/custom_appbar_component.dart';
import 'package:qbix/screens/words/word_widgets.dart';
import 'package:qbix/services/a_services.dart';
import 'package:qbix/services/statusbar_service.dart';
import 'package:qbix/theme/app_colors.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';

import 'home_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AfterLayoutMixin<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageState _pageState = PageState.LOADED;
  String _message = "";

  @override
  void initState() {
    super.initState();
    appLogs(Screens.HomeScreen, tag: screenTag);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _onLoad();
    StatusBarService.changeStatusColor(
      AppColors.primary,
    );
  }

  _onLoad() async {
    appLogs("HomeScreen:_onLoad");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.white,
      appBar: appBarCustom(
        title: Strings.home,
        leading: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(
            FontAwesomeIcons.bars,
            color: AppColors.white,
            size: Sizes.s25,
          ),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
      ),
      drawer: HomeDrawer(
        scaffoldKey: _scaffoldKey,
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              child: Image(
                height: Sizes.screenWidthHalf,
                image: AssetImage(
                  Assets.HomeBackground,
                ),
                fit: BoxFit.contain,
              ),
            ),
            Container(
              height: Sizes.s100,
              width: Sizes.screenWidthHalf,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  "Hello, ${auth.currentUser.personalInformation.firstName}",
                  style: TextStyles.defaultSemiBold.copyWith(
                    fontSize: FontSize.s30,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        P10(),
        Text(
          "Word of the Day",
          style: TextStyles.defaultBold.copyWith(fontSize: FontSize.s20),
          textAlign: TextAlign.center,
        ),
        C10(),
        Flexible(
          child: WordWidget(),
        )
      ],
    );
  }

  _showLoading() {
    appLogs("HomeScreen:_showLoading");
    setState(() => _pageState = PageState.LOADING);
  }

  _hideLoading() {
    appLogs("HomeScreen:_hideLoading");
    setState(() => _pageState = PageState.LOADED);
  }

  _showError() {
    appLogs("HomeScreen:_showError");
    setState(() => _pageState = PageState.ERROR);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
