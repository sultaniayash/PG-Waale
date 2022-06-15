import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qbix/components/buttons_component.dart';
import 'package:qbix/components/custom_appbar_component.dart';
import 'package:qbix/models/user_model.dart';
import 'package:qbix/services/a_services.dart';
import 'package:qbix/services/auth_service.dart';
import 'package:qbix/theme/app_colors.dart';
import 'package:qbix/theme/textstyles.dart';
import 'package:qbix/utils/a_utils.dart';
import 'package:qbix/widgets/background_widget.dart';
import 'package:qbix/widgets/logo_widget.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;
  final String password;

  const VerifyEmailScreen({
    Key key,
    @required this.email,
    @required this.password,
  }) : super(key: key);

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageState _pageState = PageState.LOADED;

  @override
  void initState() {
    super.initState();
    appLogs(Screens.VerifyEmailScreen, tag: screenTag);
  }

  @override
  void dispose() {
    super.dispose();
  }

  _showLoading() {
    appLogs("VerifyEmailScreen:showLoading");
    setState(() => _pageState = PageState.LOADING);
  }

  _hideLoading() {
    appLogs("VerifyEmailScreen:hideLoading");
    setState(() => _pageState = PageState.LOADED);
  }

  _checkIfEmailVerified() async {
    _showLoading();
    try {
      FirebaseUser _firebaseUser = await FirebaseSignIn.signIn(
        email: widget.email,
        password: widget.password,
      );
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

        _hideLoading();
        await Auth.redirectUserAsPerStatus(context);
      } else {
        _hideLoading();
        AppToast.showMessage(Strings.verifyEmailToProceed);
      }
    } catch (e, s) {
      handelException(context, e, s, "_checkIfEmailVerified ");
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Sizes.s40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          appBarCustom(
            title: Strings.verifyEmail,
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
            "A verification email has beed sent to your email id \n ${widget.email} ",
            style: TextStyles.defaultSemiBold,
            textAlign: TextAlign.center,
          ),
          P10(),
          Text(
            Strings.verifyEmailToProceed,
            style: TextStyles.defaultRegular.copyWith(
              color: Colors.grey.shade800,
              fontSize: FontSize.s13,
            ),
            textAlign: TextAlign.center,
          ),
          Flexible(child: Container()),
          AppButton(
            onTap: _checkIfEmailVerified,
            title: Strings.proceed,
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
            firstTitle: Strings.noReceiveEmail,
            secondTitle: Strings.sendAgain,
            textAlign: TextAlign.center,
            onTap: () async {
              _showLoading();
              try {
                await FirebaseSignIn.signIn(
                    email: widget.email, password: widget.password);
                AppToast.showMessage(Strings.emailSent);
                _hideLoading();
              } catch (e, s) {
                appLogs("Error in Re - sendEmailVerification  $e,\n$s");
                AppToast.showMessage(Strings.defaultErrorMessage);
                _hideLoading();
              }
            },
          ),
          P30(),
        ],
      ),
    );
  }
}
