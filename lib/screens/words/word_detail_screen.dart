import 'package:flutter/material.dart';
import 'package:qbix/components/app_components.dart';
import 'package:qbix/screens/words/word_model.dart';
import 'package:qbix/theme/app_colors.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';

class WordDetailScreen extends StatefulWidget {
  final WordModel word;

  const WordDetailScreen({
    Key key,
    @required this.word,
  }) : super(key: key);

  @override
  _WordDetailScreenState createState() => _WordDetailScreenState();
}

class _WordDetailScreenState extends State<WordDetailScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageState _pageState = PageState.LOADED;
  String _message = "";

  @override
  void initState() {
    super.initState();
    appLogs(Screens.WordDetailScreen, tag: screenTag);
    Future.delayed(Duration(milliseconds: Constants.delaySmall), () => _onLoad());
  }

  _onLoad() async {
    appLogs("TutorialScreen:_onLoad");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.white,
      appBar: appBarCustom(title: "Word of the Day"),
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
    return ListView(
      padding: EdgeInsets.all(Sizes.s12),
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(Sizes.s10),
          padding: EdgeInsets.all(Sizes.s10),
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(Sizes.s8),
              border: Border.all(
                color: Colors.grey.shade400,
                width: 0.3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400,
                  blurRadius: Sizes.s10,
                  spreadRadius: -Sizes.s6,
                  offset: Offset(0, 2),
                ),
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              C10(),
              Text(
                dateDOBFormatter.format(DateTime.now()),
                style: TextStyles.defaultRegular.copyWith(
                  color: Colors.red.shade300,
                ),
              ),
              Container(
                height: Sizes.s100,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    "${widget.word.word}",
                    style: TextStyles.defaultSemiBold.copyWith(
                      fontSize: FontSize.s20,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.word.definitions.isNotEmpty)
          Text(
            "definitions",
            style: TextStyles.defaultRegular.copyWith(
              fontSize: FontSize.s12,
            ),
          ),
        C5(),
        if (widget.word.definitions.isNotEmpty)
          ...widget.word.definitions
              .map((definition) => Padding(
                    padding: EdgeInsets.all(Sizes.s12),
                    child: Text(
                      "${definition.text}",
                      style: TextStyles.defaultItalic.copyWith(
                        color: Colors.red.shade600,
                        fontSize: FontSize.s14,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ))
              .toList(),
        if (widget.word.examples.isNotEmpty)
          Text(
            "examples",
            style: TextStyles.defaultRegular.copyWith(
              fontSize: FontSize.s12,
            ),
          ),
        C5(),
        if (widget.word.examples.isNotEmpty)
          ...widget.word.examples
              .map((example) => Padding(
                    padding: EdgeInsets.all(Sizes.s12),
                    child: Text(
                      "${example.text}",
                      style: TextStyles.defaultItalic.copyWith(
                        color: Colors.blue.shade600,
                        fontSize: FontSize.s14,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ))
              .toList(),
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
