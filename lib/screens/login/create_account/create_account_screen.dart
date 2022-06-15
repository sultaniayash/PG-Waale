import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qbix/components/app_components.dart';
import 'package:qbix/screens/login/verify_email/verify_email_screen.dart';
import 'package:qbix/services/firebase_service.dart';
import 'package:qbix/theme/app_colors.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';
import 'package:qbix/widgets/background_widget.dart';
import 'package:qbix/widgets/logo_widget.dart';

import '../../../app_config.dart';

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageState _pageState = PageState.LOADED;

  final _formKey = GlobalKey<FormState>();
  List<FocusNode> _focusNodes = List.generate(3, (_) => FocusNode());

  String _email = "";
  String _password = "";
  String _rePassword = "";

  @override
  void initState() {
    super.initState();
    if (App.devMode) {
      _email = "ajay@virtoustack.com";
      _password = "admin123";
      _rePassword = "admin123";
    }
    appLogs(Screens.CreateAccountScreen, tag: screenTag);
  }

  @override
  void dispose() {
    _focusNodes.forEach((_) => _.dispose());
    super.dispose();
  }

  _showLoading() {
    appLogs("CreateAccountScreen:_showLoading");
    setState(() => _pageState = PageState.LOADING);
  }

  _hideLoading() {
    appLogs("CreateAccountScreen:_hideLoading");
    setState(() => _pageState = PageState.LOADED);
  }

  _createAccount() async {
    if (!isFormValid(_formKey)) return;

    if (_password != _rePassword) {
      AppToast.showMessage("Passwords do not match");
      return;
    }

    try {
      _showLoading();
      FirebaseUser _firebaseUser = await FirebaseSignIn.createUser(
        email: _email,
        password: _password,
      );
      if (_firebaseUser != null) {
        AppRoutes.makeFirst(
            context,
            VerifyEmailScreen(
              email: _email,
              password: _password,
            ));
      } else {
        AppToast.showMessage(Strings.loginFailed);
      }

      _hideLoading();
    } catch (e, s) {
      handelException(context, e, s, "_createAccount Error");
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
          _getBody(),
          ScreenLoader(pageState: _pageState),
        ],
      ),
    );
  }

  Widget _getBody() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: Sizes.s40),
        children: <Widget>[
          appBarCustom(
            title: Strings.createAccount,
            backgroundColor: Colors.transparent,
            style: TextStyles.appBarTittle.copyWith(
              color: Colors.grey.shade600,
            ),
            leading: C0(),
          ),
          P5(),
          AppLogoWidget(
            margin: EdgeInsets.symmetric(horizontal: Sizes.s100),
          ),
          P10(),
          Text(
            Strings.createAccountEmail,
            style: TextStyles.defaultSemiBold,
            textAlign: TextAlign.center,
          ),
          P10(),
          Text(
            Strings.verificationEmail,
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
            focusNode: _focusNodes[0],
            validator: AppValidator.validateEmail,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onSaved: (value) => _email = value.trim(),
            onFieldSubmitted: (_) => setFocus(context, focusNode: _focusNodes[1]),
            initialValue: _email,
          ),
          P10(),
          AppTextFormField(
            label: Strings.createPassword,
            hintText: Strings.createPassword,
            obscureText: true,
            focusNode: _focusNodes[1],
            validator: AppValidator.validatePassword,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onSaved: (value) => _password = value.trim(),
            onFieldSubmitted: (_) => setFocus(context, focusNode: _focusNodes[2]),
            initialValue: _password,
          ),
          P10(),
          AppTextFormField(
            label: Strings.reenterPassword,
            hintText: Strings.reenterPassword,
            obscureText: true,
            focusNode: _focusNodes[2],
            validator: AppValidator.validatePassword,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onSaved: (value) => _rePassword = value.trim(),
            onFieldSubmitted: (_) => setFocus(context),
            initialValue: _rePassword,
          ),
          P10(),
          AppButton(
            onTap: _createAccount,
            title: Strings.createAccount.toUpperCase(),
          ),
          P10(),
          Row(
            children: <Widget>[
              Expanded(child: Container()),
              Expanded(
                child: Container(
                  height: Sizes.s1,
                  color: Colors.grey.shade500,
                ),
              ),
              C5(),
              Text(
                Strings.or,
                style: TextStyles.labelStyle,
              ),
              C5(),
              Expanded(
                child: Container(
                  height: Sizes.s1,
                  color: Colors.grey.shade500,
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
          P10(),
          TwoTextLink(
            firstTitle: Strings.alreadyAccount,
            secondTitle: Strings.login,
            textAlign: TextAlign.center,
            onTap: () {
              AppRoutes.pop(context);
            },
          )
        ],
      ),
    );
  }
}
