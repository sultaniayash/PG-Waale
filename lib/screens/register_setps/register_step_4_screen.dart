import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qbix/components/app_components.dart';
import 'package:qbix/components/custom_appbar_component.dart';
import 'package:qbix/models/register_models.dart';
import 'package:qbix/screens/register_setps/register_step_5_screen.dart';
import 'package:qbix/screens/register_setps/register_widgets.dart';
import 'package:qbix/services/a_services.dart';
import 'package:qbix/theme/app_colors.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/theme/textstyles.dart';
import 'package:qbix/utils/a_utils.dart';

class RegisterStep4Screen extends StatefulWidget {
  @override
  _RegisterStep4ScreenState createState() => _RegisterStep4ScreenState();
}

class _RegisterStep4ScreenState extends State<RegisterStep4Screen> with AfterLayoutMixin<RegisterStep4Screen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageState _pageState = PageState.LOADING;
  String _message = "";

  int _step = 4;
  ExperienceInformation _experienceInformation = ExperienceInformation.empty();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _experienceInformation = auth.currentUser.experienceInformation;
    appLogs(Screens.RegisterStep4Screen, tag: screenTag);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _onLoad();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _onLoad() async {
    appLogs("RegisterStep4Screen:_onLoad");
    _hideLoading();
  }

  _showLoading() {
    appLogs("RegisterStep4Screen:_showLoading");
    setState(() => _pageState = PageState.LOADING);
  }

  _hideLoading() {
    appLogs("RegisterStep4Screen:_hideLoading");
    setState(() => _pageState = PageState.LOADED);
  }

  _saveExperienceInformation() async {
    if (!isFormValid(_formKey)) return;
    _showLoading();
    try {
      await FirebaseApi(FirestoreCollection.students).updateDocument(id: auth.currentUser.uid, data: {
        APIKeys.experienceInformation: _experienceInformation.toMap(),
      });
      _hideLoading();
      AppRoutes.push(context, RegisterStep5Screen());
    } catch (e, s) {
      handelException(context, e, s, "_savePersonalInformation");
      _hideLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarCustom(
        title: Strings.registrationTitle,
        backgroundColor: Colors.transparent,
        style: TextStyles.appBarTittle.copyWith(
          color: Colors.grey.shade600,
        ),
        leading: C0(),
      ),
      backgroundColor: AppColors.white,
      body: Stack(
        children: <Widget>[
          getBody(),
          ScreenLoader(pageState: _pageState),
          AppErrorWidget(
            message: _message,
            pageState: _pageState,
            onTap: _onLoad,
          )
        ],
      ),
    );
  }

  Widget getBody() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Sizes.s40),
            child: Text(
              Strings.registrationHeading,
              style: TextStyles.defaultSemiBold,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Sizes.s40),
            child: RegisterProgressWidget(
              activeStep: _step,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Sizes.s40),
            child: Text(
              Strings.workExperience,
              style: TextStyles.defaultSemiBold.copyWith(
                fontSize: Sizes.s12,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          P10(),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Sizes.s40),
              child: InkResponse(
                  child: Icon(
                    FontAwesomeIcons.plusCircle,
                    color: Colors.green.shade500,
                    size: Sizes.s35,
                  ),
                  onTap: () {
                    showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) {
                          return AddExperienceWidget(
                            callBack: (Experience experience) {
                              setState(() {
                                _experienceInformation.experiences.add(experience);
                              });
                              AppRoutes.pop(context);
                            },
                            experience: Experience.empty(),
                          );
                        });
                  }),
            ),
          ),
          P10(),
          if (_experienceInformation.experiences.isEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: Sizes.s40),
              child: Image(
                  image: AssetImage(
                Assets.AppointmentConfirmed,
              )),
            ),
          Flexible(
            child: ListView.builder(
              key: Key('${_experienceInformation.experiences.length}'),
              padding: EdgeInsets.symmetric(horizontal: Sizes.s40),
              itemCount: _experienceInformation.experiences.length,
              itemBuilder: (context, index) {
                return ExperienceWidget(
                  key: Key(_experienceInformation.experiences[index].toMap().toString()),
                  experience: _experienceInformation.experiences[index],
                  onTap: () {
                    showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) {
                          return AddExperienceWidget(
                            callBack: (Experience experience) {
                              setState(() {
                                _experienceInformation.experiences[index] = experience;
                              });
                              AppRoutes.pop(context);
                            },
                            experience: _experienceInformation.experiences[index],
                          );
                        });
                  },
                  onDelete: () {
                    setState(() {
                      _experienceInformation.experiences.removeAt(index);
                    });
                  },
                );
              },
            ),
          ),
          AppButton(
            onTap: _saveExperienceInformation,
            title: _experienceInformation.experiences.isEmpty ? Strings.skipAndContinue : Strings.saveAndContinue,
          ),
          P10(),
        ],
      ),
    );
  }
}
