import 'package:flutter/material.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';

class TutorialPage {
  String image;
  String heading;

  TutorialPage({
    @required this.image,
    @required this.heading,
  });
}

class TutorialPageWidget extends StatelessWidget {
  final TutorialPage page;

  const TutorialPageWidget({Key key, @required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.only(
              top: Sizes.s50,
            ),
            padding: EdgeInsets.only(
              left: Sizes.s30,
              right: Sizes.s30,
              top: Sizes.s50,
              bottom: Sizes.s25,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image(
                  image: AssetImage(page.image),
                  fit: BoxFit.contain,
                )
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: Sizes.s100, horizontal: Sizes.s10),
          child: Text(
            page.heading,
            style: TextStyles.defaultRegular.copyWith(
              fontSize: FontSize.s30,
              fontFamily: FontFamily.regular,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int length;

  const PageIndicator({
    Key key,
    @required this.currentPage,
    @required this.length,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List pageList = new List.generate(length, (index) => index);
    List<Widget> children = List();
    pageList.forEach((index) {
      children.add(SelectorWidget(
        active: currentPage == index,
      ));
    });
    return Container(
      padding: EdgeInsets.all(Sizes.s20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }
}

class SelectorWidget extends StatelessWidget {
  final bool active;

  const SelectorWidget({Key key, @required this.active}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: EdgeInsets.symmetric(horizontal: Sizes.s5),
      duration: Duration(milliseconds: Constants.delayMedium),
      height: Sizes.s8,
      width: active ? Sizes.s30 : Sizes.s15,
      decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.secondary,
          borderRadius: BorderRadius.all(Radius.circular(Sizes.s8))),
    );
  }
}
