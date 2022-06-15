import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qbix/components/app_components.dart';
import 'package:qbix/models/user_model.dart';
import 'package:qbix/screens/login/verify_email/verify_email_screen.dart';
import 'package:qbix/screens/register_setps/register_step_1_screen.dart';
import 'package:qbix/services/auth_service.dart';
import 'package:qbix/services/firebase_service.dart';
import 'package:qbix/theme/app_colors.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';
import 'package:qbix/widgets/background_widget.dart';
import 'package:qbix/widgets/logo_widget.dart';

import '../../app_config.dart';
import 'create_account/create_account_screen.dart';
import 'forgot_password/forgot_password.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageState _pageState = PageState.LOADED;
  String _message = "";

  final _formKey = GlobalKey<FormState>();
  List<FocusNode> _focusNodes = List.generate(2, (_) => FocusNode());

  String _email = "";
  String _password = "";

  @override
  void initState() {
    if (App.devMode) {
      _email = "ajay@virtoustack.com";
      _password = "Admin@123";
    }
    super.initState();
    appLogs(Screens.LoginScreen, tag: screenTag);
  }

  @override
  void dispose() {
    _focusNodes.forEach((_) => _.dispose());
    super.dispose();
  }

  _showLoading() {
    appLogs("LoginScreen:_showLoading");
    setState(() => _pageState = PageState.LOADING);
  }

  _hideLoading() {
    appLogs("LoginScreen:_hideLoading");
    setState(() => _pageState = PageState.LOADED);
  }

  _login() async {
    if (!isFormValid(_formKey)) return;

    try {
      _showLoading();
      FirebaseUser _firebaseUser = await FirebaseSignIn.signIn(
        email: _email,
        password: _password,
      );

      if (_firebaseUser != null) {
        if (_firebaseUser.isEmailVerified) {
          ///save user email and mark as logged in
          User _user = User.fromUIDAndEmail(
            uid: _firebaseUser.uid,
            email: _firebaseUser.email,
          );
          _user.log();
          await auth.updateUserInSharedPreference(_user);
          await FirebaseApi(FirestoreCollection.students)
              .updateDocument(id: auth.currentUser.uid, data: {
            APIKeys.uid: _firebaseUser.uid,
            APIKeys.emailId: _firebaseUser.email,
          });
          await Auth.redirectUserAsPerStatus(context);
          _hideLoading();
        } else {
          AppRoutes.makeFirst(
              context,
              VerifyEmailScreen(
                email: _email,
                password: _password,
              ));
        }
      } else {
        AppToast.showMessage(Strings.loginFailed);
      }

      _hideLoading();
    } catch (e, s) {
      handelException(context, e, s, "_Login Error");
      _hideLoading();
    }
  }

  _signInWithGoogle() async {
    try {
      _showLoading();
      FirebaseUser _firebaseUser = await FirebaseSignIn.signInWithGoogle();
      if (_firebaseUser != null) {
        ///save user email and mark as logged in
        User _user = User.fromUIDAndEmail(
          uid: _firebaseUser.uid,
          email: _firebaseUser.email,
        );
        _user.log();
        await auth.updateUserInSharedPreference(_user);
        await FirebaseApi(FirestoreCollection.students)
            .updateDocument(id: auth.currentUser.uid, data: {
          APIKeys.uid: _firebaseUser.uid,
          APIKeys.emailId: _firebaseUser.email,
        });
        _hideLoading();
        AppRoutes.makeFirst(context, RegisterStep1Screen());
      } else {
        _hideLoading();
        AppToast.showMessage(Strings.loginFailed);
      }
    } catch (e, s) {
      handelException(context, e, s, "_Login");
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
            title: Strings.login,
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
            Strings.signInWithEmailPassword,
            style: TextStyles.defaultSemiBold,
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
            onFieldSubmitted: (_) =>
                setFocus(context, focusNode: _focusNodes[1]),
            initialValue: _email,
          ),
          P10(),
          AppTextFormField(
            label: Strings.password,
            hintText: Strings.password,
            obscureText: true,
            focusNode: _focusNodes[1],
            validator: AppValidator.validatePassword,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onSaved: (value) => _password = value.trim(),
            onFieldSubmitted: (_) => setFocus(context),
            initialValue: _password,
          ),
          P5(),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
                onTap: () {
                  AppRoutes.push(context, ForgotPasswordScreen());
                },
                text: Strings.forgotPassword),
          ),
          P5(),
          AppButton(
            onTap: _login,
            title: Strings.login,
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
          InkWell(
            onTap: _signInWithGoogle,
            child: Container(
              height: Sizes.s40,
              margin: EdgeInsets.symmetric(
                horizontal: Sizes.s50,
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.RegisterWithGoogle),
                ),
              ),
            ),
          ),
          P10(),
          TwoTextLink(
            firstTitle: Strings.newUser,
            secondTitle: Strings.createAccount.toUpperCase(),
            textAlign: TextAlign.center,
            onTap: () {
              AppRoutes.push(context, CreateAccountScreen());
            },
          )
        ],
      ),
    );
  }
}
