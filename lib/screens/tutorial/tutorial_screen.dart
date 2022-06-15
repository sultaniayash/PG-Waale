import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:qbix/components/app_components.dart';
import 'package:qbix/screens/tutorial/tutorial_widgets.dart';
import 'package:qbix/theme/app_colors.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';
import 'package:qbix/widgets/background_widget.dart';

class TutorialScreen extends StatefulWidget {
  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> with AfterLayoutMixin<TutorialScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageState _pageState = PageState.LOADING;
  String _message = "";

  PageController _pageController = new PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    appLogs(Screens.TutorialScreen, tag: screenTag);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _onLoad();
  }

  _onLoad() async {
    appLogs("TutorialScreen:_onLoad");
    _hideLoading();
  }

  updateCurrentPage(int page) {
    setState(() {
      _currentPage = page;
    });
    appLogs("_currentPage:$_currentPage");
  }

  List<TutorialPage> _pageList = [
    TutorialPage(
      image: Assets.VS,
      heading: Strings.tutorialHeading1,
    ),
    TutorialPage(
      image: Assets.VS,
      heading: Strings.tutorialHeading2,
    ),
    TutorialPage(
      image: Assets.VS,
      heading: Strings.tutorialHeading3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.white,
      body: Stack(
        children: <Widget>[
          BackgroundWidget(),
          BackgroundOverlayWidget(),
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
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Flexible(
              child: PageView(
                controller: _pageController,
                onPageChanged: updateCurrentPage,
                children: _pageList.map((page) {
                  return TutorialPageWidget(page: page);
                }).toList(),
              ),
            ),
            PageIndicator(
              currentPage: _currentPage,
              length: _pageList.length,
            ),
            P5(),
            AppButton(
              title: Strings.getStarted,
              onTap: () {},
            )
          ],
        )
      ],
    );
  }

  _showLoading() {
    appLogs("TutorialScreen:_showLoading");
    setState(() => _pageState = PageState.LOADING);
  }

  _hideLoading() {
    appLogs("TutorialScreen:_hideLoading");
    setState(() => _pageState = PageState.LOADED);
  }

  _showError() {
    appLogs("TutorialScreen:_showError");
    setState(() => _pageState = PageState.ERROR);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
