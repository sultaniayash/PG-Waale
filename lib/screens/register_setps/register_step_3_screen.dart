import 'package:after_layout/after_layout.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qbix/components/app_components.dart';
import 'package:qbix/components/buttons_component.dart';
import 'package:qbix/components/custom_appbar_component.dart';
import 'package:qbix/components/date_picker_field.dart';
import 'package:qbix/models/master_data_model.dart';
import 'package:qbix/models/register_models.dart';
import 'package:qbix/screens/register_setps/register_step_4_screen.dart';
import 'package:qbix/screens/register_setps/register_widgets.dart';
import 'package:qbix/services/a_services.dart';
import 'package:qbix/theme/app_colors.dart';
import 'package:qbix/theme/textstyles.dart';
import 'package:qbix/utils/a_utils.dart';

class RegisterStep3Screen extends StatefulWidget {
  @override
  _RegisterStep3ScreenState createState() => _RegisterStep3ScreenState();
}

class _RegisterStep3ScreenState extends State<RegisterStep3Screen> with AfterLayoutMixin<RegisterStep3Screen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageState _pageState = PageState.LOADING;

  int _step = 3;
  CoursesCountriesInformation _coursesCountriesInformation = CoursesCountriesInformation.empty();

  @override
  void initState() {
    super.initState();
    _coursesCountriesInformation = auth.currentUser.coursesCountriesInformation;
    appLogs(Screens.RegisterStep3Screen, tag: screenTag);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    __onLoad();
  }

  @override
  void dispose() {
    super.dispose();
  }

  __onLoad() async {
    appLogs("RegisterStep3Screen:_onLoad");
    _hideLoading();
  }

  _showLoading() {
    appLogs("RegisterStep3Screen:_showLoading");
    setState(() => _pageState = PageState.LOADING);
  }

  _hideLoading() {
    appLogs("RegisterStep3Screen:_hideLoading");
    setState(() => _pageState = PageState.LOADED);
  }

  _saveCoursesCountriesInformation() async {
    if (_coursesCountriesInformation.courses.isEmpty) {
      showSnackBar(title: "Please select atleat one course!", scaffoldKey: _scaffoldKey);
      return;
    }
    if (_coursesCountriesInformation.countries.isEmpty) {
      showSnackBar(title: "Please select atleat one country!", scaffoldKey: _scaffoldKey);
      return;
    }
    _coursesCountriesInformation.log();

    _showLoading();
    try {
      await FirebaseApi(FirestoreCollection.students).updateDocument(id: auth.currentUser.uid, data: {
        APIKeys.coursesCountriesInformation: _coursesCountriesInformation.toMap(),
      });
      _hideLoading();
      AppRoutes.push(context, RegisterStep4Screen());
    } catch (e, s) {
      handelException(context, e, s, "_saveEducationInformation");
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
    return ListView(
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
          Strings.coursesAndCountriesInterested,
          style: TextStyles.defaultSemiBold.copyWith(
            fontSize: Sizes.s12,
            color: Colors.grey.shade500,
          ),
          textAlign: TextAlign.center,
        ),
        P10(),
        InputDecorator(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: Sizes.s10, vertical: Sizes.s10),
            hintText: "",
            hintStyle: TextStyles.hintStyle,
            errorStyle: TextStyles.errorStyle,
            labelStyle: TextStyles.labelStyle,
            labelText: Strings.courseChoice,
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
                      children: _coursesCountriesInformation.courses
                          .map(
                            (course) => Container(
                              padding: EdgeInsets.all(Sizes.s2),
                              margin: EdgeInsets.symmetric(horizontal: Sizes.s5),
                              child: InputChip(
                                label: Row(
                                  children: <Widget>[
                                    Expanded(child: Text(course)),
                                  ],
                                ),
                                onDeleted: () {
                                  setState(() {
                                    _coursesCountriesInformation.courses.remove(course);
                                  });
                                },
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                C10(),
                InkResponse(
                    child: Icon(
                      FontAwesomeIcons.plusCircle,
                      color: Colors.green.shade500,
                    ),
                    onTap: () {
                      Picker picker = new Picker(
                        adapter: PickerDataAdapter<String>(pickerdata: MasterData.get().courses),
                        textAlign: TextAlign.left,
                        columnPadding: EdgeInsets.zero,
                        onConfirm: (Picker picker, List<int> selected) {
                          String newCourse = MasterData.get().courses[selected.first];
                          if (_coursesCountriesInformation.courses.contains(newCourse)) {
                            showSnackBar(scaffoldKey: _scaffoldKey, title: Strings.courseAlreadyAdded);
                          } else {
                            setState(() {
                              _coursesCountriesInformation.courses.add(newCourse);
                            });
                          }
                        },
                        confirmText: Strings.add,
                        confirmTextStyle: TextStyles.buttonText.copyWith(
                          color: AppColors.primary,
                        ),
                        cancelTextStyle: TextStyles.buttonText.copyWith(
                          color: Colors.grey.shade500,
                        ),
                        backgroundColor: Colors.white,
                        headercolor: Colors.white,
                      );
                      picker.show(_scaffoldKey.currentState);
                    }),
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
            labelText: Strings.countryChoice,
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
                      children: _coursesCountriesInformation.countries
                          .map(
                            (country) => Container(
                              padding: EdgeInsets.all(Sizes.s2),
                              margin: EdgeInsets.symmetric(horizontal: Sizes.s5),
                              child: InputChip(
                                label: Row(
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
                                onDeleted: () {
                                  setState(() {
                                    _coursesCountriesInformation.countries.remove(country);
                                  });
                                },
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                C10(),
                InkResponse(
                    child: Icon(
                      FontAwesomeIcons.plusCircle,
                      color: Colors.green.shade500,
                    ),
                    onTap: () {
                      Picker picker = new Picker(
                        adapter: PickerDataAdapter(
                            data: MasterData.get()
                                .countries
                                .map((country) => PickerItem(
                                    text: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: Sizes.s10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          CountryPickerUtils.getDefaultFlagImage(Country.fromMap(country.toMap())),
                                          SizedBox(width: Sizes.s10),
                                          Flexible(child: Text(country.name))
                                        ],
                                      ),
                                    ),
                                    value: country))
                                .toList()),
                        textAlign: TextAlign.left,
                        columnPadding: EdgeInsets.zero,
                        onConfirm: (Picker picker, List<int> selected) {
                          int contains = _coursesCountriesInformation.countries.indexWhere(
                              (appCountry) => appCountry.name == MasterData.get().countries[selected.first].name);
                          if (contains > -1) {
                            showSnackBar(scaffoldKey: _scaffoldKey, title: Strings.countryAlreadyAdded);
                          } else {
                            setState(() {
                              _coursesCountriesInformation.countries.add(MasterData.get().countries[selected.first]);
                            });
                          }
                        },
                        confirmText: Strings.add,
                        confirmTextStyle: TextStyles.buttonText.copyWith(
                          color: AppColors.primary,
                        ),
                        cancelTextStyle: TextStyles.buttonText.copyWith(
                          color: Colors.grey.shade500,
                        ),
                        backgroundColor: Colors.white,
                        headercolor: Colors.white,
                      );
                      picker.show(_scaffoldKey.currentState);
                    }),
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
                dateTime: _coursesCountriesInformation.startingMonth,
                onChange: (DateTime dateTime) {
                  setState(() {
                    _coursesCountriesInformation.startingMonth = dateTime;
                  });
                },
              ),
            ),
            P5(),
            Expanded(
              child: FormatDatePickerField(
                dateFormat: DateFormats.inYear,
                label: Strings.startingYear,
                hintText: Strings.startingYear,
                dateTime: _coursesCountriesInformation.startingYear,
                onChange: (DateTime dateTime) {
                  setState(() {
                    _coursesCountriesInformation.startingYear = dateTime;
                  });
                },
              ),
            ),
          ],
        ),
        P5(),
        AppButton(
          onTap: _saveCoursesCountriesInformation,
          title: Strings.saveAndContinue,
        ),
        P10(),
      ],
    );
  }
}
