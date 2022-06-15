import 'package:flutter/material.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';

import '../components/buttons_component.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  final String buttonText;
  final String image;
  final Function onTap;
  final Widget child;
  final bool showButton;
  final PageState pageState;

  const AppErrorWidget({
    Key key,
    @required this.message,
    @required this.pageState,
    this.buttonText,
    @required this.onTap,
    this.child,
    this.image,
    this.showButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (child != null) {
      return Offstage(
        offstage: pageState != PageState.ERROR,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[child],
          ),
        ),
      );
    }

    return Offstage(
      offstage: pageState != PageState.ERROR,
      child: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(Sizes.s50),
              child: Image(
                height: Sizes.s150 * 2,
                image: AssetImage(image ?? Assets.NoResults),
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(Sizes.s10),
              child: Text(
                message,
                style: TextStyles.defaultRegular.copyWith(
                  fontSize: FontSize.s18,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: Sizes.s30, horizontal: Sizes.s40),
              child: showButton
                  ? AppButton(
                      title: buttonText ?? Strings.retry,
                      onTap: onTap ?? () {},
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
