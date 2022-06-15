import 'package:flutter/material.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';

class FontFamily {
  static const String Black = "Montserrat-Black";
  static const String SemiBold = "Montserrat-SemiBold";
  static const String thin = "Montserrat-Thin";
  static const String thinItalic = "Montserrat-ThinItalic";
  static const String bold = "Montserrat-Bold";
  static const String boldItalic = "Montserrat-BoldItalic";
  static const String semiBoldItalic = "Montserrat-SemiBoldItalic";
  static const String extraBoldItalic = "Montserrat-ExtraBoldItalic";
  static const String extraItalic = "Montserrat-ExtraBold";
  static const String italic = "Montserrat-Italic";
  static const String light = "Montserrat-Light";
  static const String extraLight = "Montserrat-ExtraLight";
  static const String lightItalic = "Montserrat-LightItalic";
  static const String extraLightItalic = "Montserrat-ExtraLightItalic";
  static const String medium = "Montserrat-Medium";
  static const String mediumItalic = "Montserrat-MediumItalic";
  static const String regular = "Montserrat-Regular";
}

class TextStyles {
  static const TextDecoration underline = TextDecoration.underline;
  static const TextDecoration lineThrough = TextDecoration.lineThrough;

  static TextStyle get defaultRegular => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: FontSize.s16,
        color: Colors.black,
        inherit: false,
      );

  static TextStyle get drawerItem => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: FontSize.s16,
        color: AppColors.primary,
        inherit: false,
      );

  static TextStyle get defaultItalic => TextStyle(
        fontFamily: FontFamily.italic,
        fontSize: FontSize.s16,
        color: Colors.black,
        inherit: false,
      );

  static TextStyle get wordDefinitions => TextStyle(
        fontFamily: FontFamily.italic,
        fontSize: FontSize.s15,
        color: Colors.black,
        inherit: false,
      );

  static TextStyle get defaultSemiBold => TextStyle(
        fontFamily: FontFamily.SemiBold,
        fontSize: FontSize.s16,
        color: Colors.black,
        inherit: false,
      );

  static TextStyle get defaultBold => TextStyle(
        fontFamily: FontFamily.SemiBold,
        fontWeight: FontWeight.bold,
        fontSize: FontSize.s16,
        color: Colors.black,
        inherit: false,
      );

  static TextStyle get alertText => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: FontSize.s16,
        color: Colors.black,
        inherit: false,
      );

  static TextStyle get alertTitle => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: FontSize.s22,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.60,
        inherit: false,
      );

  static TextStyle get snackBarText => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: FontSize.s15,
        color: Colors.white,
        letterSpacing: 1.4,
        inherit: false,
      );

  static TextStyle get editText => TextStyle(
        fontFamily: FontFamily.SemiBold,
        fontWeight: FontWeight.bold,
        fontSize: FontSize.s17,
        color: Colors.black,
        inherit: false,
        textBaseline: TextBaseline.alphabetic,
      );

  static TextStyle get valueText => TextStyle(
        fontFamily: FontFamily.SemiBold,
        fontWeight: FontWeight.bold,
        fontSize: FontSize.s16,
        color: Colors.black,
        inherit: false,
        textBaseline: TextBaseline.alphabetic,
      );

  static TextStyle get labelStyle => TextStyle(
        fontFamily: FontFamily.SemiBold,
        fontSize: FontSize.s14,
        color: Colors.grey.shade600,
        inherit: false,
      );

  static TextStyle get hintStyle => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: FontSize.s14,
        color: Colors.grey.shade600,
        inherit: false,
      );

  static TextStyle get errorStyle => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: FontSize.s13,
        color: AppColors.primary,
        inherit: false,
      );

  static TextStyle get buttonText => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: FontSize.s18,
        color: Colors.white,
        letterSpacing: 0.13,
        inherit: false,
      );

  static TextStyle get appBarTittle => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: FontSize.s16,
        color: AppColors.white,
        letterSpacing: 0.11,
        fontWeight: FontWeight.bold,
        inherit: false,
      );

  static TextStyle get screenHeader => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: FontSize.s16,
        color: Colors.black,
        letterSpacing: 0.11,
        fontWeight: FontWeight.bold,
        inherit: false,
      );

  static TextStyle get screenSubHeader => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: FontSize.s13,
        color: Colors.grey.shade600,
        letterSpacing: 0.11,
        fontWeight: FontWeight.bold,
        inherit: false,
      );

  static TextStyle get TaskListScreenSubHeading => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: FontSize.s15,
        color: Colors.grey.shade600,
        letterSpacing: 0.11,
        fontWeight: FontWeight.bold,
        inherit: false,
      );

  static TextStyle get cardColoredSubHeader => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: FontSize.s16,
        color: Colors.white,
        letterSpacing: 0.11,
        fontWeight: FontWeight.bold,
        inherit: false,
      );

  static TextStyle get cardSubHeading => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: FontSize.s14,
        color: Colors.grey.shade600,
        letterSpacing: 0.11,
        fontWeight: FontWeight.bold,
        inherit: false,
      );

  static TextStyle get cardColoredHeader => TextStyle(
        fontFamily: FontFamily.regular,
        fontSize: FontSize.s15,
        color: Colors.white,
        letterSpacing: 0.11,
        fontWeight: FontWeight.bold,
        inherit: false,
      );
}
