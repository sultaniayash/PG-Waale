import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qbix/components/app_components.dart';
import 'package:qbix/theme/app_theme.dart';

AppBar appBarCustom({
  @required String title,
  Widget leading,
  double height,
  Color backgroundColor,
  Color color,
  Color buttonColor,
  TextStyle style,
  List<Widget> actions,
}) {
  return AppBar(
    backgroundColor: backgroundColor ?? AppColors.primary,
    elevation: 0.0,
    leading: leading ??
        AppBackButton(
          color: buttonColor,
        ),
    titleSpacing: 0.0,
    title: Text(
      title,
      style: style ??
          TextStyles.appBarTittle.copyWith(
            color: color ?? Colors.white,
          ),
    ),
    centerTitle: true,
    actions: actions,
  );
}
