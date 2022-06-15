import 'package:flutter/material.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/sizes.dart';

ThemeData themeData = ThemeData(
  iconTheme: new IconThemeData(size: Sizes.s20, color: Colors.black),
  brightness: Brightness.light,
  primarySwatch: Colors.red,
  primaryColor: AppColors.primary,
  primaryColorBrightness: Brightness.light,
  primaryColorLight: AppColors.secondary,
  primaryColorDark: AppColors.primary,
  accentColor: AppColors.secondary,
  accentColorBrightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  bottomAppBarColor: AppColors.secondary,
  cardColor: Colors.white,
  dividerColor: Colors.black,
  splashFactory: InkSplash.splashFactory,
  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  fontFamily: FontFamily.regular,
);
