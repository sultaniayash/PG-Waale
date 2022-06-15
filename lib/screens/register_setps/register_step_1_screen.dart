import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:qbix/components/app_radio_widgets.dart';
import 'package:qbix/components/buttons_component.dart';
import 'package:qbix/components/custom_appbar_component.dart';
import 'package:qbix/components/date_picker_field.dart';
import 'package:qbix/components/text_fields_component.dart';
import 'package:qbix/models/register_models.dart';
import 'package:qbix/screens/register_setps/register_step_2_screen.dart';
import 'package:qbix/screens/register_setps/register_widgets.dart';
import 'package:qbix/services/a_services.dart';
import 'package:qbix/theme/app_colors.dart';
import 'package:qbix/theme/textstyles.dart';
import 'package:qbix/utils/a_utils.dart';

class RegisterStep1Screen extends StatefulWidget {
  @override
  _RegisterStep1ScreenState createState() => _RegisterStep1ScreenState();
}

class _RegisterStep1ScreenState extends State<RegisterStep1Screen> with AfterLayoutMixin<RegisterStep1Screen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageState _pageState = PageState.LOADING;

  String _mobileNumber = "";
  int _step = 1;
  PersonalInformation _personalInformation = PersonalInformation.empty();

  final _formKey = GlobalKey<FormState>();
  List<FocusNode> _focusNodes = List.generate(3, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    _personalInformation = auth.currentUser.personalInformation;
    _mobileNumber = auth.currentUser.mobileNumber;
    appLogs(Screens.RegisterStep1Screen, tag: screenTag);
  }

  @override
  void dispose() {
    _focusNodes.forEach((_) => _.dispose());
    super.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    __onLoad();
  }

  _showLoading() {
    appLogs("RegisterStep1Screen:_showLoading");
    setState(() => _pageState = PageState.LOADING);
  }

  _hideLoading() {
    appLogs("RegisterStep1Screen:_hideLoading");
    setState(() => _pageState = PageState.LOADED);
  }

  __onLoad() async {
    appLogs("RegisterStep1Screen:_onLoad");
    _hideLoading();
  }

  _savePersonalInformation() async {
    if (!isFormValid(_formKey)) return;
    _showLoading();
    try {
      await FirebaseApi(FirestoreCollection.students).updateDocument(id: auth.currentUser.uid, data: {
        APIKeys.personalInformation: _personalInformation.toMap(),
        APIKeys.mobileNumber: _mobileNumber,
      });
      _hideLoading();
      AppRoutes.push(context, RegisterStep2Screen());
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
          Text(
            Strings.registrationHeading,
            style: TextStyles.defaultSemiBold,
            textAlign: TextAlign.center,
          ),
          RegisterProgressWidget(
            activeStep: _step,
          ),
          Text(
            Strings.personalDetails,
            style: TextStyles.defaultSemiBold.copyWith(
              fontSize: Sizes.s12,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
          P10(),
          AppTextFormField(
            label: Strings.firstName,
            hintText: Strings.firstName,
            focusNode: _focusNodes[0],
            validator: AppValidator.validateName,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onSaved: (value) => _personalInformation.firstName = value.trim(),
            onFieldSubmitted: (_) => setFocus(context, focusNode: _focusNodes[1]),
            initialValue: _personalInformation.firstName,
          ),
          P10(),
          AppTextFormField(
            label: Strings.lastName,
            hintText: Strings.lastName,
            focusNode: _focusNodes[1],
            validator: AppValidator.validateName,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onSaved: (value) => _personalInformation.lastName = value.trim(),
            onFieldSubmitted: (_) => setFocus(context, focusNode: _focusNodes[2]),
            initialValue: _personalInformation.lastName,
          ),
          P10(),
          AppTextFormField(
            label: Strings.mobileNumber,
            hintText: Strings.mobileNumber,
            focusNode: _focusNodes[2],
            validator: AppValidator.validatePhone,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onSaved: (value) => _mobileNumber = value.trim(),
            onFieldSubmitted: (_) => setFocus(context),
            initialValue: _mobileNumber,
          ),
          P5(),
          P5(),
          DatePickerField(
            label: Strings.DOB,
            hintText: Strings.DOB,
            dateTime: _personalInformation.dob,
            onChange: (DateTime dateTime) {
              setState(() {
                _personalInformation.dob = dateTime;
              });
            },
          ),
          P5(),
          GenderRadioWidget(
            label: Strings.gender,
            hintText: Strings.gender,
            gender: _personalInformation.gender,
            onChange: (String gender) {
              setState(() {
                _personalInformation.gender = gender;
              });
            },
          ),
          P5(),
          AppTextFormField(
            label: Strings.address,
            hintText: Strings.address,
            validator: AppValidator.validateEmptyCheck,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            onSaved: (value) => _personalInformation.address = value.trim(),
            onFieldSubmitted: (_) => setFocus(context),
            maxLines: 3,
            initialValue: _personalInformation.address,
          ),
          P5(),
          AppButton(
            onTap: _savePersonalInformation,
            title: Strings.saveAndContinue,
          ),
          P10(),
        ],
      ),
    );
  }
}
