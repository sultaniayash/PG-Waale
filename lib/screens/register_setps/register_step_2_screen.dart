import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:qbix/components/app_radio_widgets.dart';
import 'package:qbix/components/buttons_component.dart';
import 'package:qbix/components/custom_appbar_component.dart';
import 'package:qbix/components/date_picker_field.dart';
import 'package:qbix/components/text_fields_component.dart';
import 'package:qbix/models/register_models.dart';
import 'package:qbix/screens/register_setps/register_step_3_screen.dart';
import 'package:qbix/screens/register_setps/register_widgets.dart';
import 'package:qbix/services/a_services.dart';
import 'package:qbix/services/auth_service.dart';
import 'package:qbix/theme/app_colors.dart';
import 'package:qbix/theme/textstyles.dart';
import 'package:qbix/utils/a_utils.dart';

class RegisterStep2Screen extends StatefulWidget {
  @override
  _RegisterStep2ScreenState createState() => _RegisterStep2ScreenState();
}

class _RegisterStep2ScreenState extends State<RegisterStep2Screen> with AfterLayoutMixin<RegisterStep2Screen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageState _pageState = PageState.LOADING;

  int _step = 2;

  EducationInformation _educationInformation = EducationInformation.empty();

  PageController _pageController = new PageController();
  int _currentPage = 0;

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();

  List<FocusNode> _focusNodes = List.generate(8, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    _educationInformation = auth.currentUser.educationInformation;
    appLogs(Screens.RegisterStep2Screen, tag: screenTag);
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
    appLogs("RegisterStep2Screen:_showLoading");
    setState(() => _pageState = PageState.LOADING);
  }

  _hideLoading() {
    appLogs("RegisterStep2Screen:_hideLoading");
    setState(() => _pageState = PageState.LOADED);
  }

  __onLoad() async {
    appLogs("RegisterStep2Screen:_onLoad");
    _hideLoading();
  }

  _updateCurrentPage(int page) {
    setState(() {
      _currentPage = page;
    });
    appLogs("_currentPage:$_currentPage");
  }

  _goto(int page) {
    _pageController.animateToPage(page, duration: Duration(milliseconds: Constants.delaySmall), curve: Curves.bounceIn);
    appLogs("goto:$_currentPage");
  }

  _saveEducationInformation() async {
    if (!isFormValid(_formKey4)) return;
    _showLoading();
    try {
      await FirebaseApi(FirestoreCollection.students).updateDocument(id: auth.currentUser.uid, data: {
        APIKeys.educationInformation: _educationInformation.toMap(),
      });
      _hideLoading();
      AppRoutes.push(context, RegisterStep3Screen());
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
          _getBody(),
          ScreenLoader(pageState: _pageState),
        ],
      ),
    );
  }

  Widget _getBody() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Sizes.s40),
      child: Column(
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
            Strings.academicQualifications,
            style: TextStyles.defaultSemiBold.copyWith(
              fontSize: Sizes.s12,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
          P10(),
          Flexible(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: _updateCurrentPage,
              children: [
                /* --------10th-----------   */
                _tenThWidget(),
                /* --------12th/Diploma :-----------   */
                _diplomaWidget(),
                /* --------Bachelors : :-----------   */
                _bachelorsWidget(),
                /* --------Masters : :-----------   */
                _mastersWidget(),
              ],
            ),
          ),
          P10(),
        ],
      ),
    );
  }

  Widget _tenThWidget() {
    return Form(
      key: _formKey1,
      child: ListView(
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
            focusNode: _focusNodes[0],
            validator: AppValidator.validateEmptyCheck,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onSaved: (value) => _educationInformation.tenTh.board = value.trim(),
            onFieldSubmitted: (_) => setFocus(context, focusNode: _focusNodes[1]),
            initialValue: _educationInformation.tenTh.board,
          ),
          P10(),
          AppTextFormField(
            label: Strings.subject,
            hintText: Strings.subject,
            focusNode: _focusNodes[1],
            validator: AppValidator.validateEmptyCheck,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            onSaved: (value) => _educationInformation.tenTh.subject = value.trim(),
            onFieldSubmitted: (_) => setFocus(context),
            initialValue: _educationInformation.tenTh.subject,
          ),
          P5(),
          Row(
            children: <Widget>[
              Expanded(
                child: FormatDatePickerField(
                  dateFormat: DateFormats.inYear,
                  label: Strings.from,
                  hintText: Strings.from,
                  dateTime: _educationInformation.tenTh.fromDate,
                  onChange: (DateTime dateTime) {
                    setState(() {
                      _educationInformation.tenTh.fromDate = dateTime;
                    });
                  },
                ),
              ),
              P5(),
              Expanded(
                child: FormatDatePickerField(
                  dateFormat: DateFormats.inYear,
                  label: Strings.to,
                  hintText: Strings.to,
                  dateTime: _educationInformation.tenTh.toDate,
                  onChange: (DateTime dateTime) {
                    setState(() {
                      _educationInformation.tenTh.toDate = dateTime;
                    });
                  },
                ),
              ),
            ],
          ),
          P10(),
          AppButton(
            onTap: () {
              if (!isFormValid(_formKey1)) return;
              _goto(1);
            },
            title: Strings.next,
          ),
        ],
      ),
    );
  }

  Widget _diplomaWidget() {
    return Form(
      key: _formKey2,
      child: ListView(
        children: <Widget>[
          Text(
            Strings.diploma,
            style: TextStyles.defaultSemiBold,
            textAlign: TextAlign.left,
          ),
          P5(),
          EducationTypeRadioWidget(
            type: _educationInformation.diplomaOr12Th.type,
            onChange: (String type) {
              setState(() {
                _educationInformation.diplomaOr12Th.type = type;
              });
            },
          ),
          P5(),
          AppTextFormField(
            label: Strings.awardingBodyBoard,
            hintText: Strings.awardingBodyBoard,
            focusNode: _focusNodes[2],
            validator: AppValidator.validateEmptyCheck,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onSaved: (value) => _educationInformation.diplomaOr12Th.board = value.trim(),
            onFieldSubmitted: (_) => setFocus(context, focusNode: _focusNodes[3]),
            initialValue: _educationInformation.diplomaOr12Th.board,
          ),
          P10(),
          AppTextFormField(
            label: Strings.subject,
            hintText: Strings.subject,
            focusNode: _focusNodes[3],
            validator: AppValidator.validateEmptyCheck,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            onSaved: (value) => _educationInformation.diplomaOr12Th.subject = value.trim(),
            onFieldSubmitted: (_) => setFocus(context),
            initialValue: _educationInformation.diplomaOr12Th.subject,
          ),
          P5(),
          Row(
            children: <Widget>[
              Expanded(
                child: FormatDatePickerField(
                  dateFormat: DateFormats.inYear,
                  label: Strings.from,
                  hintText: Strings.from,
                  dateTime: _educationInformation.diplomaOr12Th.fromDate,
                  onChange: (DateTime dateTime) {
                    setState(() {
                      _educationInformation.diplomaOr12Th.fromDate = dateTime;
                    });
                  },
                ),
              ),
              P5(),
              Expanded(
                child: FormatDatePickerField(
                  dateFormat: DateFormats.inYear,
                  label: Strings.to,
                  hintText: Strings.to,
                  dateTime: _educationInformation.diplomaOr12Th.toDate,
                  onChange: (DateTime dateTime) {
                    setState(() {
                      _educationInformation.diplomaOr12Th.toDate = dateTime;
                    });
                  },
                ),
              ),
            ],
          ),
          P10(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: AppButton(
                  margin: EdgeInsets.symmetric(horizontal: Sizes.s10),
                  onTap: () {
                    _goto(0);
                  },
                  title: Strings.previous,
                ),
              ),
              Expanded(
                child: AppButton(
                  margin: EdgeInsets.symmetric(horizontal: Sizes.s10),
                  onTap: () {
                    if (!isFormValid(_formKey2)) return;
                    _goto(2);
                  },
                  title: Strings.next,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bachelorsWidget() {
    return Form(
      key: _formKey3,
      child: ListView(
        children: <Widget>[
          Text(
            Strings.bachelors,
            style: TextStyles.defaultSemiBold,
            textAlign: TextAlign.left,
          ),
          P5(),
          AppTextFormField(
            label: Strings.awardingBodyBoard,
            hintText: Strings.awardingBodyBoard,
            focusNode: _focusNodes[4],
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onSaved: (value) => _educationInformation.bachelors.board = value.trim(),
            onFieldSubmitted: (_) => setFocus(context, focusNode: _focusNodes[5]),
            initialValue: _educationInformation.bachelors.board,
          ),
          P10(),
          AppTextFormField(
            label: Strings.subject,
            hintText: Strings.subject,
            focusNode: _focusNodes[5],
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            onSaved: (value) => _educationInformation.bachelors.subject = value.trim(),
            onFieldSubmitted: (_) => setFocus(context),
            initialValue: _educationInformation.bachelors.subject,
          ),
          P5(),
          Row(
            children: <Widget>[
              Expanded(
                child: FormatDatePickerField(
                  dateFormat: DateFormats.inYear,
                  label: Strings.from,
                  hintText: Strings.from,
                  dateTime: _educationInformation.bachelors.fromDate,
                  onChange: (DateTime dateTime) {
                    setState(() {
                      _educationInformation.bachelors.fromDate = dateTime;
                    });
                  },
                ),
              ),
              P5(),
              Expanded(
                child: FormatDatePickerField(
                  dateFormat: DateFormats.inYear,
                  label: Strings.to,
                  hintText: Strings.to,
                  dateTime: _educationInformation.bachelors.toDate,
                  onChange: (DateTime dateTime) {
                    setState(() {
                      _educationInformation.bachelors.toDate = dateTime;
                    });
                  },
                ),
              ),
            ],
          ),
          P10(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: AppButton(
                  margin: EdgeInsets.symmetric(horizontal: Sizes.s10),
                  onTap: () {
                    _goto(1);
                  },
                  title: Strings.previous,
                ),
              ),
              Expanded(
                child: AppButton(
                  margin: EdgeInsets.symmetric(horizontal: Sizes.s10),
                  onTap: () {
                    if (!isFormValid(_formKey3)) return;
                    _goto(3);
                  },
                  title: Strings.next,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mastersWidget() {
    return Form(
      key: _formKey4,
      child: ListView(
        children: <Widget>[
          Text(
            Strings.masters,
            style: TextStyles.defaultSemiBold,
            textAlign: TextAlign.left,
          ),
          P5(),
          AppTextFormField(
            label: Strings.awardingBodyBoard,
            hintText: Strings.awardingBodyBoard,
            focusNode: _focusNodes[6],
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onSaved: (value) => _educationInformation.masters.board = value.trim(),
            onFieldSubmitted: (_) => setFocus(context, focusNode: _focusNodes[7]),
            initialValue: _educationInformation.masters.board,
          ),
          P10(),
          AppTextFormField(
            label: Strings.subject,
            hintText: Strings.subject,
            focusNode: _focusNodes[7],
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            onSaved: (value) => _educationInformation.masters.subject = value.trim(),
            onFieldSubmitted: (_) => setFocus(context),
            initialValue: _educationInformation.masters.subject,
          ),
          P5(),
          Row(
            children: <Widget>[
              Expanded(
                child: FormatDatePickerField(
                  dateFormat: DateFormats.inYear,
                  label: Strings.from,
                  hintText: Strings.from,
                  dateTime: _educationInformation.masters.fromDate,
                  onChange: (DateTime dateTime) {
                    setState(() {
                      _educationInformation.masters.fromDate = dateTime;
                    });
                  },
                ),
              ),
              P5(),
              Expanded(
                child: FormatDatePickerField(
                  dateFormat: DateFormats.inYear,
                  label: Strings.to,
                  hintText: Strings.to,
                  dateTime: _educationInformation.masters.toDate,
                  onChange: (DateTime dateTime) {
                    setState(() {
                      _educationInformation.masters.toDate = dateTime;
                    });
                  },
                ),
              ),
            ],
          ),
          P10(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: AppButton(
                  margin: EdgeInsets.symmetric(horizontal: Sizes.s10),
                  onTap: () {
                    _goto(2);
                  },
                  title: Strings.previous,
                ),
              ),
              Expanded(
                child: AppButton(
                  margin: EdgeInsets.symmetric(horizontal: Sizes.s10),
                  onTap: _saveEducationInformation,
                  title: Strings.Continue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
