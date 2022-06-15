import 'package:after_layout/after_layout.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:qbix/components/app_components.dart';
import 'package:qbix/components/custom_appbar_component.dart';
import 'package:qbix/components/date_picker_field.dart';
import 'package:qbix/models/app_models.dart';
import 'package:qbix/screens/profile/user_widget.dart';
import 'package:qbix/screens/register_setps/register_widgets.dart';
import 'package:qbix/theme/app_colors.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({Key key, this.user}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AfterLayoutMixin<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageState _pageState = PageState.LOADED;
  String _message = "";

  @override
  void initState() {
    super.initState();
    appLogs(Screens.ProfileScreen, tag: screenTag);
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
    appLogs("StudentProfileScreen:_onLoad");
    _hideLoading();
  }

  _showLoading() {
    appLogs("StudentProfileScreen:_showLoading");
    setState(() => _pageState = PageState.LOADING);
  }

  _hideLoading() {
    appLogs("StudentProfileScreen:_hideLoading");
    setState(() => _pageState = PageState.LOADED);
  }

  _showError() {
    appLogs("StudentProfileScreen:_showError");
    setState(() => _pageState = PageState.ERROR);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarCustom(title: "PROFILE"),
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
    return ListView(
      children: <Widget>[
        StudentHeadWidget(
          user: widget.user,
        ),
        C10(),
        Card(
          child: ExpansionTile(
            title: Text(
              Strings.personalDetails,
              style: TextStyles.defaultSemiBold.copyWith(
                fontSize: Sizes.s15,
              ),
              textAlign: TextAlign.start,
            ),
            children: [_getPersonalInformationWidget()],
          ),
        ),
        Card(
          child: ExpansionTile(
            title: Text(
              Strings.academicQualifications,
              style: TextStyles.defaultSemiBold.copyWith(
                fontSize: Sizes.s15,
              ),
              textAlign: TextAlign.start,
            ),
            children: [_getAcademicQualificationsWidget()],
          ),
        ),
        Card(
          child: ExpansionTile(
            title: Text(
              Strings.coursesAndCountriesInterested,
              style: TextStyles.defaultSemiBold.copyWith(
                fontSize: Sizes.s15,
              ),
              textAlign: TextAlign.start,
            ),
            children: [_getCoursesAndCountriesInterestedWidget()],
          ),
        ),
        Card(
          child: ExpansionTile(
            title: Text(
              Strings.workExperience_,
              style: TextStyles.defaultSemiBold.copyWith(
                fontSize: Sizes.s15,
              ),
              textAlign: TextAlign.start,
            ),
            children: [_getWorkExperienceWidget()],
          ),
        ),
        Card(
          child: ExpansionTile(
            title: Text(
              Strings.EntranceExams,
              style: TextStyles.defaultSemiBold.copyWith(
                fontSize: Sizes.s15,
              ),
              textAlign: TextAlign.start,
            ),
            children: [_getEntranceExamsWidget()],
          ),
        ),
      ],
    );
  }

  Widget _getPersonalInformationWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Sizes.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          P10(),
          AppTextFormField(
            label: Strings.firstName,
            initialValue: widget.user.personalInformation.firstName,
            enabled: false,
          ),
          P10(),
          AppTextFormField(
            label: Strings.lastName,
            initialValue: widget.user.personalInformation.lastName,
            enabled: false,
          ),
          P5(),
          AppTextFormField(
            label: Strings.mobileNumber,
            initialValue: widget.user.mobileNumber,
            enabled: false,
          ),
          P5(),
          DatePickerField(
            label: Strings.DOB,
            hintText: Strings.DOB,
            firstDate: DateTime.now().subtract(Duration(days: 36500)),
            lastDate: DateTime.now().subtract(Duration(days: 1)),
            dateTime: widget.user.personalInformation.dob,
            onChange: (DateTime dateTime) {},
            enabled: false,
          ),
          P5(),
          AppTextFormField(
            label: Strings.gender,
            hintText: Strings.gender,
            initialValue: widget.user.personalInformation.gender,
            enabled: false,
          ),
          P5(),
          AppTextFormField(
            label: Strings.address,
            hintText: Strings.address,
            initialValue: widget.user.personalInformation.address,
            enabled: false,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _getAcademicQualificationsWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Sizes.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            Strings.tenTh,
            style: TextStyles.defaultSemiBold,
            textAlign: TextAlign.left,
          ),
          P5(),
          AppTextFormField(
            label: Strings.awardingBodyBoard,
            hintText: Strings.awardingBodyBoard,
            initialValue: widget.user.educationInformation.tenTh.board,
            enabled: false,
          ),
          P10(),
          AppTextFormField(
            label: Strings.subject,
            hintText: Strings.subject,
            initialValue: widget.user.educationInformation.tenTh.subject,
            enabled: false,
          ),
          P5(),
          Row(
            children: <Widget>[
              Expanded(
                child: FormatDatePickerField(
                  dateFormat: DateFormats.inYear,
                  label: Strings.from,
                  hintText: Strings.from,
                  dateTime: widget.user.educationInformation.tenTh.fromDate,
                  onChange: (DateTime dateTime) {},
                  enabled: false,
                ),
              ),
              P5(),
              Expanded(
                child: FormatDatePickerField(
                  dateFormat: DateFormats.inYear,
                  label: Strings.to,
                  hintText: Strings.to,
                  dateTime: widget.user.educationInformation.tenTh.toDate,
                  onChange: (DateTime dateTime) {},
                  enabled: false,
                ),
              ),
            ],
          ),
          P10(),
          Text(
            widget.user.educationInformation.diplomaOr12Th.type + " :",
            style: TextStyles.defaultSemiBold,
            textAlign: TextAlign.left,
          ),
          P5(),
          AppTextFormField(
            label: Strings.awardingBodyBoard,
            hintText: Strings.awardingBodyBoard,
            initialValue: widget.user.educationInformation.diplomaOr12Th.board,
            enabled: false,
          ),
          P10(),
          AppTextFormField(
            label: Strings.subject,
            hintText: Strings.subject,
            initialValue: widget.user.educationInformation.diplomaOr12Th.subject,
            enabled: false,
          ),
          P5(),
          Row(
            children: <Widget>[
              Expanded(
                child: FormatDatePickerField(
                  dateFormat: DateFormats.inYear,
                  label: Strings.from,
                  hintText: Strings.from,
                  dateTime: widget.user.educationInformation.diplomaOr12Th.fromDate,
                  onChange: (DateTime dateTime) {},
                  enabled: false,
                ),
              ),
              P5(),
              Expanded(
                child: FormatDatePickerField(
                  dateFormat: DateFormats.inYear,
                  label: Strings.to,
                  hintText: Strings.to,
                  dateTime: widget.user.educationInformation.diplomaOr12Th.toDate,
                  onChange: (DateTime dateTime) {},
                  enabled: false,
                ),
              ),
            ],
          ),
          P10(),
          Text(
            Strings.bachelors,
            style: TextStyles.defaultSemiBold,
            textAlign: TextAlign.left,
          ),
          P5(),
          AppTextFormField(
            label: Strings.awardingBodyBoard,
            hintText: Strings.awardingBodyBoard,
            initialValue: widget.user.educationInformation.bachelors.board,
            enabled: false,
          ),
          P10(),
          AppTextFormField(
            label: Strings.subject,
            hintText: Strings.subject,
            initialValue: widget.user.educationInformation.bachelors.subject,
            enabled: false,
          ),
          P5(),
          Row(
            children: <Widget>[
              Expanded(
                child: FormatDatePickerField(
                  dateFormat: DateFormats.inYear,
                  label: Strings.from,
                  hintText: Strings.from,
                  dateTime: widget.user.educationInformation.bachelors.fromDate,
                  onChange: (DateTime dateTime) {},
                  enabled: false,
                ),
              ),
              P5(),
              Expanded(
                child: FormatDatePickerField(
                  dateFormat: DateFormats.inYear,
                  label: Strings.to,
                  hintText: Strings.to,
                  dateTime: widget.user.educationInformation.bachelors.toDate,
                  onChange: (DateTime dateTime) {},
                  enabled: false,
                ),
              ),
            ],
          ),
          P10(),
          Text(
            Strings.masters,
            style: TextStyles.defaultSemiBold,
            textAlign: TextAlign.left,
          ),
          P5(),
          AppTextFormField(
            label: Strings.awardingBodyBoard,
            hintText: Strings.awardingBodyBoard,
            initialValue: widget.user.educationInformation.masters.board,
            enabled: false,
          ),
          P10(),
          AppTextFormField(
            label: Strings.subject,
            hintText: Strings.subject,
            initialValue: widget.user.educationInformation.masters.subject,
            enabled: false,
          ),
          P5(),
          Row(
            children: <Widget>[
              Expanded(
                child: FormatDatePickerField(
                  dateFormat: DateFormats.inYear,
                  label: Strings.from,
                  hintText: Strings.from,
                  dateTime: widget.user.educationInformation.masters.fromDate,
                  onChange: (DateTime dateTime) {},
                  enabled: false,
                ),
              ),
              P5(),
              Expanded(
                child: FormatDatePickerField(
                  dateFormat: DateFormats.inYear,
                  label: Strings.to,
                  hintText: Strings.to,
                  dateTime: widget.user.educationInformation.masters.toDate,
                  onChange: (DateTime dateTime) {},
                  enabled: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getCoursesAndCountriesInterestedWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Sizes.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          InputDecorator(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: Sizes.s10, vertical: Sizes.s10),
              hintText: "",
              hintStyle: TextStyles.hintStyle,
              errorStyle: TextStyles.errorStyle,
              labelStyle: TextStyles.labelStyle,
              labelText: Strings.selectedCourse,
              errorMaxLines: Constants.errorMaxLines,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: Sizes.s5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.user.coursesCountriesInformation.courses
                            .map(
                              (course) => Container(
                                padding: EdgeInsets.all(Sizes.s2),
                                margin: EdgeInsets.symmetric(horizontal: Sizes.s5),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(child: Text(course)),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          InputDecorator(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: Sizes.s10, vertical: Sizes.s10),
              hintText: "",
              hintStyle: TextStyles.hintStyle,
              errorStyle: TextStyles.errorStyle,
              labelStyle: TextStyles.labelStyle,
              labelText: Strings.selectedCountries,
              errorMaxLines: Constants.errorMaxLines,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: Sizes.s5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.user.coursesCountriesInformation.countries
                            .map(
                              (country) => Container(
                                padding: EdgeInsets.all(Sizes.s2),
                                margin: EdgeInsets.symmetric(horizontal: Sizes.s5),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(Sizes.s2),
                                      child: Image.asset(
                                        CountryPickerUtils.getFlagImageAssetPath(country.isoCode),
                                        height: Sizes.s20,
                                        width: Sizes.s30,
                                        fit: BoxFit.fill,
                                        package: "country_pickers",
                                      ),
                                    ),
                                    C10(),
                                    Expanded(child: Text(country.name)),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          P5(),
          Row(
            children: <Widget>[
              Expanded(
                child: FormatDatePickerField(
                  label: Strings.startingMonth,
                  hintText: Strings.startingMonth,
                  dateFormat: DateFormats.inMonth,
                  dateTime: widget.user.coursesCountriesInformation.startingMonth,
                  onChange: (DateTime dateTime) {},
                  enabled: false,
                ),
              ),
              P5(),
              Expanded(
                child: FormatDatePickerField(
                  dateFormat: DateFormats.inYear,
                  label: Strings.startingYear,
                  hintText: Strings.startingYear,
                  dateTime: widget.user.coursesCountriesInformation.startingYear,
                  onChange: (DateTime dateTime) {},
                  enabled: false,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _getWorkExperienceWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Sizes.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widget.user.experienceInformation.experiences
            .map((experience) => ExperienceWidget(
                  experience: experience,
                  onTap: null,
                  onDelete: null,
                ))
            .toList(),
      ),
    );
  }

  Widget _getEntranceExamsWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Sizes.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widget.user.examInformation.exams
            .map((exam) => ExamWidget(
                  exam: exam,
                  onTap: null,
                  onDelete: null,
                ))
            .toList(),
      ),
    );
  }
}
