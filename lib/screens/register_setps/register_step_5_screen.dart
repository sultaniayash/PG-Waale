import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qbix/components/app_components.dart';
import 'package:qbix/components/custom_appbar_component.dart';
import 'package:qbix/models/register_models.dart';
import 'package:qbix/screens/appointment/appointment_select_counsellor_screen.dart';
import 'package:qbix/screens/register_setps/register_widgets.dart';
import 'package:qbix/services/a_services.dart';
import 'package:qbix/theme/app_colors.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/theme/textstyles.dart';
import 'package:qbix/utils/a_utils.dart';

class RegisterStep5Screen extends StatefulWidget {
  @override
  _RegisterStep5ScreenState createState() => _RegisterStep5ScreenState();
}

class _RegisterStep5ScreenState extends State<RegisterStep5Screen> with AfterLayoutMixin<RegisterStep5Screen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageState _pageState = PageState.LOADING;
  String _message = "";

  int _step = 5;
  ExamInformation _examInformation = ExamInformation.empty();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    appLogs(Screens.RegisterStep5Screen, tag: screenTag);
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
    appLogs("RegisterStep5Screen:_onLoad");
    _hideLoading();
  }

  _showLoading() {
    appLogs("RegisterStep5Screen:_showLoading");
    setState(() => _pageState = PageState.LOADING);
  }

  _hideLoading() {
    appLogs("RegisterStep5Screen:_hideLoading");
    setState(() => _pageState = PageState.LOADED);
  }

  _saveExamInformation() async {
    if (!isFormValid(_formKey)) return;
    _showLoading();
    try {
      await FirebaseApi(FirestoreCollection.students).updateDocument(id: auth.currentUser.uid, data: {
        APIKeys.examInformation: _examInformation.toMap(),
        APIKeys.leadStatus: LeadStatus.NEW,
        APIKeys.isInfoComplete: true,
      });
      await FirebaseSignIn.updateUserData();
      _hideLoading();
      AppRoutes.makeFirst(context, AppointmentSelectCounsellorScreen(isFirstAppointment: true));
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
              "Entrance Exams (if given)",
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
                          return AddExamWidget(
                            callBack: (Exam exam) {
                              setState(() {
                                _examInformation.exams.add(exam);
                              });
                              AppRoutes.pop(context);
                            },
                            exam: Exam.empty(),
                          );
                        });
                  }),
            ),
          ),
          P10(),
          if (_examInformation.exams.isEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: Sizes.s40),
              child: Image(
                  image: AssetImage(
                Assets.AppointmentConfirmed,
              )),
            ),
          Flexible(
            child: ListView.builder(
              key: Key('${_examInformation.exams.length}'),
              padding: EdgeInsets.symmetric(horizontal: Sizes.s40),
              itemCount: _examInformation.exams.length,
              itemBuilder: (context, index) {
                return ExamWidget(
                  key: Key(_examInformation.exams[index].toMap().toString()),
                  exam: _examInformation.exams[index],
                  onTap: () {
                    showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) {
                          return AddExamWidget(
                            callBack: (Exam exam) {
                              setState(() {
                                _examInformation.exams[index] = exam;
                              });
                              AppRoutes.pop(context);
                            },
                            exam: _examInformation.exams[index],
                          );
                        });
                  },
                  onDelete: () {
                    setState(() {
                      _examInformation.exams.removeAt(index);
                    });
                  },
                );
              },
            ),
          ),
          AppButton(
            onTap: _saveExamInformation,
            title: _examInformation.exams.isEmpty ? Strings.skipAndContinue : Strings.saveAndContinue,
          ),
          P10(),
        ],
      ),
    );
  }
}
