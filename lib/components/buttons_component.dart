import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';

class AppButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final String title;

  final Color color;
  final bool enabled;
  final bool boxShadow;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final TextStyle style;
  final TextAlign textAlign;

  AppButton({
    @required this.onTap,
    @required this.title,
    this.enabled = true,
    this.boxShadow = false,
    this.color,
    this.padding,
    this.margin,
    this.textAlign,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : () {},
      child: Container(
        padding: padding ?? EdgeInsets.symmetric(horizontal: Sizes.s25, vertical: Sizes.s15),
        margin: margin ?? EdgeInsets.zero,
        child: Text(
          title,
          style: style ?? TextStyles.buttonText,
          textAlign: textAlign ?? TextAlign.center,
        ),
        decoration: BoxDecoration(
            color: enabled ? (color ?? AppColors.primary) : AppColors.primary,
            boxShadow: boxShadow
                ? [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: Sizes.s20,
                    ),
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: Sizes.s20,
                    ),
                  ]
                : []),
      ),
    );
  }
}

class TextButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final String text;
  final TextStyle textStyle;
  final bool enabled;
  final EdgeInsetsGeometry padding;

  TextButton({
    @required this.onTap,
    @required this.text,
    this.textStyle,
    this.padding,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : () {},
      child: Container(
        padding: padding ?? Sizes.spacingAllSmall,
        child: Text(
          text,
          style: textStyle ?? TextStyles.labelStyle,
        ),
      ),
    );
  }
}

class AppOutLineButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final String text;
  final TextStyle textStyle;
  final bool enabled;
  final EdgeInsetsGeometry padding;
  final Color color;

  AppOutLineButton({
    @required this.onTap,
    @required this.text,
    this.color,
    this.textStyle,
    this.padding,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : () {},
      splashColor: AppColors.secondary,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(Sizes.s8)),
          border: Border.all(
            color: color ?? AppColors.primary,
            width: Sizes.s1,
          ),
        ),
        padding: padding ??
            EdgeInsets.symmetric(
              horizontal: Sizes.s25,
              vertical: Sizes.s10,
            ),
        child: Text(
          text,
          style: textStyle ??
              TextStyles.buttonText.copyWith(
                color: Colors.black,
                fontSize: FontSize.s10,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class TwoTextLink extends StatelessWidget {
  final String firstTitle;
  final String secondTitle;
  final Function onTap;
  final TextStyle firstStyle;
  final TextStyle secondStyle;
  final TextAlign textAlign;
  final EdgeInsetsGeometry padding;

  const TwoTextLink({
    Key key,
    @required this.firstTitle,
    @required this.secondTitle,
    @required this.onTap,
    @required this.textAlign,
    this.firstStyle,
    this.padding,
    this.secondStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(Sizes.s10),
      child: RichText(
        textAlign: textAlign,
        text: TextSpan(
          text: firstTitle,
          style: firstStyle ??
              TextStyles.defaultRegular.copyWith(
                fontSize: FontSize.s13,
                color: Colors.black,
              ),
          children: <TextSpan>[
            TextSpan(
              text: " ",
            ),
            TextSpan(
              text: secondTitle,
              style: secondStyle ??
                  TextStyles.defaultSemiBold.copyWith(
                    fontSize: FontSize.s16,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    decoration: TextStyles.underline,
                  ),
              recognizer: TapGestureRecognizer()..onTap = onTap,
            )
          ],
        ),
      ),
    );
  }
}

class AppBackButton extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Function onTap;
  final Color color;

  const AppBackButton({
    Key key,
    this.padding,
    this.onTap,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: padding ?? EdgeInsets.zero,
      icon: Icon(
        FontAwesomeIcons.solidArrowAltCircleLeft,
        color: color ?? AppColors.white,
        size: Sizes.s30,
      ),
      onPressed: onTap ??
          () {
            Navigator.maybePop(context);
          },
    );
  }
}
