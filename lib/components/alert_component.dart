import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';
import 'package:qbix/utils/sizes.dart';

enum ButtonType { positiveButton, negativeButton }

void showAlert({
  @required BuildContext context,
  @required String message,
  @required String title,
  String positiveButtonText,
  Function positiveButtonOnTap,
}) {
  showCupertinoModalPopup(
    context: context,
    builder: (_) => AppAlert(
      title: title ?? AlertTitle.alert,
      positiveButtonOnTap: positiveButtonOnTap ?? () {},
      message: message,
      positiveButtonText: positiveButtonText,
    ),
  );
}

void showAlertWithTwoOption(
    {@required BuildContext context,
    @required String message,
    @required String title,
    @required GestureTapCallback positiveButtonOnTap,
    @required GestureTapCallback negativeButtonOnTap,
    String positiveButtonText,
    String negativeButtonText,
    String image,
    bool popAfter = true,
    bool barrierDismissible = false}) {
  showCupertinoModalPopup(
    context: context,
    builder: (_) => AppAlert(
      title: title,
      message: message,
      positiveButtonText: positiveButtonText,
      positiveButtonOnTap: positiveButtonOnTap,
      negativeButtonText: negativeButtonText,
      negativeButtonOnTap: negativeButtonOnTap,
      popAfter: popAfter,
      image: image,
    ),
  );
}

void showWIPAlert({@required BuildContext context}) {
  showCupertinoModalPopup(
    context: context,
    builder: (_) => AppAlert(
      title: AlertTitle.warning,
      positiveButtonOnTap: () {},
      message: Strings.wip,
    ),
  );
}

void showEXITAlert({@required BuildContext context}) {
  showCupertinoModalPopup(
    context: context,
    builder: (_) => AppAlert(
      title: "",
      positiveButtonOnTap: () {},
      image: Assets.VS,
      message: Strings.exit,
      negativeButtonOnTap: () {
        SystemNavigator.pop();
      },
      negativeButtonText: Strings.positiveButtonText,
      positiveButtonText: Strings.negativeButtonText,
    ),
  );
}

class AppAlert extends StatefulWidget {
  final String message;
  final String title;
  final String image;
  final String positiveButtonText;
  final String negativeButtonText;
  final GestureTapCallback positiveButtonOnTap;
  final GestureTapCallback negativeButtonOnTap;
  final bool popAfter;

  AppAlert({
    @required this.title,
    @required this.message,
    @required this.positiveButtonOnTap,
    this.negativeButtonOnTap,
    this.positiveButtonText,
    this.negativeButtonText,
    this.popAfter = true,
    this.image,
  });

  @override
  _AppAlertState createState() => _AppAlertState();
}

class _AppAlertState extends State<AppAlert> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(
        child: Center(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: Sizes.s80),
                  padding: EdgeInsets.only(top: Sizes.s10),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        spreadRadius: 1.0,
                        blurRadius: screenWidth,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(Sizes.s8),
                    color: Colors.white,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        P10(),
                        Text(
                          widget.title,
                          style: TextStyles.alertTitle.copyWith(color: AppColors.primary),
                          textAlign: TextAlign.center,
                        ),
                        P10(),
                        Padding(
                          padding: EdgeInsets.only(left: Sizes.s5, right: Sizes.s5),
                          child: Text(
                            widget.message,
                            style: TextStyles.alertText,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        P10(),
                        (widget.negativeButtonText == null && widget.negativeButtonOnTap == null)
                            ? AlertButton(
                                buttonType: ButtonType.positiveButton,
                                text: widget.positiveButtonText,
                                callback: () async {
                                  if (widget.popAfter) {
                                    appLogs("Alert-------------> poped");
                                    AppRoutes.dismissAlert(context);
                                  }
                                  widget.positiveButtonOnTap();

                                  appLogs("Alert-------------> positiveButton");
                                },
                              )
                            : Wrap(
                                alignment: WrapAlignment.spaceEvenly,
                                children: <Widget>[
                                  AlertButton(
                                    buttonType: ButtonType.negativeButton,
                                    text: widget.negativeButtonText,
                                    callback: () async {
                                      if (widget.popAfter) {
                                        appLogs("Alert-------------> poped");
                                        AppRoutes.dismissAlert(context);
                                      }
                                      widget.negativeButtonOnTap();

                                      appLogs("Alert-------------> negativeButton");
                                    },
                                  ),
                                  AlertButton(
                                    buttonType: ButtonType.positiveButton,
                                    text: widget.positiveButtonText,
                                    callback: () async {
                                      if (widget.popAfter) {
                                        appLogs("Alert-------------> poped");
                                        AppRoutes.dismissAlert(context);
                                      }
                                      widget.positiveButtonOnTap();

                                      appLogs("Alert-------------> positiveButton");
                                    },
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AlertButton extends StatelessWidget {
  final String text;
  final GestureTapCallback callback;
  final ButtonType buttonType;

  const AlertButton({
    Key key,
    this.text,
    @required this.callback,
    @required this.buttonType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        constraints: BoxConstraints(
          minHeight: Sizes.s50,
          maxHeight: Sizes.s50,
        ),
        decoration: new BoxDecoration(
          borderRadius: (buttonType == ButtonType.positiveButton)
              ? BorderRadius.only(
                  bottomLeft: Radius.circular(Sizes.s5),
                  bottomRight: Radius.circular(Sizes.s5),
                )
              : BorderRadius.only(
                  topRight: Radius.circular(Sizes.s5),
                  topLeft: Radius.circular(Sizes.s5),
                ),
          color: (buttonType == ButtonType.positiveButton) ? AppColors.primary : Colors.grey.shade400,
        ),
        padding: EdgeInsets.symmetric(horizontal: Sizes.s5),
        child: Center(
          child: Text(
            (buttonType == ButtonType.positiveButton)
                ? (text ?? Strings.positiveButtonText.toUpperCase())
                : (text ?? Strings.negativeButtonText.toUpperCase()),
            style: TextStyles.buttonText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      onTap: callback,
    );
  }
}
