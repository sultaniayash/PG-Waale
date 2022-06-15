import 'package:flutter/material.dart';
import 'package:qbix/app_config.dart';
import 'package:qbix/components/app_components.dart';
import 'package:qbix/components/buttons_component.dart';
import 'package:qbix/services/a_services.dart';
import 'package:qbix/theme/app_colors.dart';
import 'package:qbix/theme/assets.dart';
import 'package:qbix/theme/textstyles.dart';
import 'package:qbix/utils/a_utils.dart';
import 'package:qbix/widgets/background_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageState _pageState = PageState.LOADED;

  final _formKey = GlobalKey<FormState>();
  String _email = "";

  @override
  void initState() {
    super.initState();
    if (App.devMode) {
      _email = "contact@virtoustack.com";
    }
    appLogs(Screens.ForgotPasswordScreen, tag: screenTag);
  }

  @override
  void dispose() {
    super.dispose();
  }

  _showLoading() {
    appLogs("ForgotPasswordScreen:_showLoading");
    setState(() => _pageState = PageState.LOADING);
  }

  _hideLoading() {
    appLogs("ForgotPasswordScreen:_hideLoading");
    setState(() => _pageState = PageState.LOADED);
  }

  _sendPasswordResetEmail() async {
    if (!isFormValid(_formKey)) return;
    _showLoading();
    try {
      await FirebaseSignIn.sendPasswordResetEmail(email: _email);
      _hideLoading();
      showAlert(
          context: context,
          message: Strings.sentResetPasswordLink,
          title: Strings.resetPassword,
          positiveButtonOnTap: () {
            AppRoutes.pop(context);
          });
    } catch (e, s) {
      handelException(context, e, s, "_sendPasswordResetEmail Error");
      _hideLoading();
    }
  }

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
        ],
      ),
    );
  }

  Widget getBody() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: Sizes.s40),
        children: <Widget>[
          appBarCustom(
            title: Strings.forgotPassword,
            backgroundColor: Colors.transparent,
            style: TextStyles.appBarTittle.copyWith(
              color: Colors.grey.shade600,
            ),
            buttonColor: Colors.grey.shade500,
          ),
          P5(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: Sizes.s60),
            child: Image(
              image: AssetImage(Assets.ForgotPassword),
              fit: BoxFit.contain,
            ),
          ),
          P10(),
          Text(
            Strings.changePassword,
            style: TextStyles.defaultSemiBold,
            textAlign: TextAlign.center,
          ),
          P10(),
          Text(
            Strings.resetPasswordLink,
            style: TextStyles.defaultRegular.copyWith(
              color: Colors.grey.shade800,
              fontSize: FontSize.s13,
            ),
            textAlign: TextAlign.center,
          ),
          P20(),
          AppTextFormField(
            label: Strings.emailID,
            hintText: Strings.emailID,
            validator: AppValidator.validateEmail,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onSaved: (value) => _email = value.trim(),
            onFieldSubmitted: (_) => setFocus(context),
            initialValue: _email,
          ),
          P5(),
          AppButton(
            onTap: _sendPasswordResetEmail,
            title: Strings.send,
          ),
          P10(),
        ],
      ),
    );
  }
}
