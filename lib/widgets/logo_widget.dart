import 'package:flutter/material.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/theme/assets.dart';
import 'package:qbix/utils/a_utils.dart';

class AppLogoWidget extends StatelessWidget {
  final bool isWhite;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final double height;

  const AppLogoWidget({Key key, this.isWhite = true, this.margin, this.padding, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "AppLogoWidget",
      child: Container(
        margin: margin ?? EdgeInsets.zero,
        padding: padding ?? Sizes.spacingAllSmall,
        child: Image(
          image: AssetImage(Assets.QbixLogo),
          fit: BoxFit.contain,
          height: height,
        ),
      ),
    );
  }
}
