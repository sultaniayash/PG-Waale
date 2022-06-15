import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qbix/components/buttons_component.dart';
import 'package:qbix/components/date_picker_field.dart';
import 'package:qbix/components/text_fields_component.dart';
import 'package:qbix/models/register_models.dart';
import 'package:qbix/theme/app_colors.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';

class RegisterProgressWidget extends StatelessWidget {
  final int activeStep;

  const RegisterProgressWidget({Key key, @required this.activeStep}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "RegisterProgressWidget",
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Sizes.s20,
          vertical: Sizes.s15,
        ),
        child: Row(
          children: <Widget>[
            ProgressWidget(
              isActive: 1 <= activeStep,
            ),
            LineWidget(isActive: 2 <= activeStep),
            ProgressWidget(
              isActive: 2 <= activeStep,
            ),
            LineWidget(isActive: 3 <= activeStep),
            ProgressWidget(
              isActive: 3 <= activeStep,
            ),
            LineWidget(isActive: 4 <= activeStep),
            ProgressWidget(
              isActive: 4 <= activeStep,
            ),
            LineWidget(isActive: 5 <= activeStep),
            ProgressWidget(
              isActive: 5 <= activeStep,
            ),
          ],
        ),
      ),
    );
  }
}

class LineWidget extends StatelessWidget {
  final bool isActive;

  const LineWidget({Key key, this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: isActive ? Sizes.s3 : Sizes.s1,
        color: isActive ? AppColors.primary : Colors.grey.shade500,
      ),
    );
  }
}

class ProgressWidget extends StatelessWidget {
  final bool isActive;

  const ProgressWidget({Key key, @required this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: Sizes.s10,
      backgroundColor: isActive ? AppColors.primary : Colors.grey.shade500,
      child: CircleAvatar(
        radius: isActive ? Sizes.s6 : Sizes.s8,
        backgroundColor: AppColors.white,
      ),
    );
  }
}

class ExperienceWidget extends StatelessWidget {
  final Experience experience;
  final Function onTap;
  final Function onDelete;

  const ExperienceWidget({Key key, @required this.experience, @required this.onTap, @required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        InkResponse(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.all(Sizes.s6),
            padding: EdgeInsets.all(Sizes.s6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(Sizes.s10)),
              border: Border.all(
                color: AppColors.pinkishGrey,
                width: Sizes.s1,
              ),
              boxShadow: [
                BoxShadow(
                  spreadRadius: -Sizes.s6,
                  blurRadius: Sizes.s15,
                  color: AppColors.pinkishGrey,
                  offset: Offset(Sizes.s2, Sizes.s2),
                )
              ],
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: FormatDatePickerField(
                        dateFormat: DateFormats.inMonthYear,
                        label: Strings.from,
                        hintText: Strings.from,
                        dateTime: experience.fromDate,
                        onChange: (DateTime dateTime) {},
                        enabled: false,
                      ),
                    ),
                    P5(),
                    Expanded(
                      child: FormatDatePickerField(
                        dateFormat: DateFormats.inMonthYear,
                        label: Strings.to,
                        hintText: Strings.to,
                        dateTime: experience.toDate,
                        onChange: (DateTime dateTime) {},
                        enabled: false,
                      ),
                    ),
                  ],
                ),
                AppTextFormField(
                  label: Strings.postHeld,
                  hintText: Strings.postHeld,
                  validator: AppValidator.validateName,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onSaved: (value) => experience.position = value.trim(),
                  enabled: false,
                  initialValue: experience.position,
                ),
                P10(),
                AppTextFormField(
                  label: Strings.organisationNameLocation,
                  hintText: Strings.organisationNameLocation,
                  validator: AppValidator.validateName,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  onSaved: (value) => experience.organisationName = value.trim(),
                  enabled: false,
                  initialValue: experience.organisationName,
                ),
                P5(),
                AppTextFormField(
                  label: Strings.descriptionDuties,
                  hintText: Strings.descriptionDuties,
                  validator: AppValidator.validateEmptyCheck,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  onSaved: (value) => experience.description = value.trim(),
                  maxLines: 3,
                  enabled: false,
                  initialValue: experience.description,
                ),
                P5(),
              ],
            ),
          ),
        ),
        if (onDelete != null)
          Align(
            alignment: Alignment.topRight,
            child: InkResponse(
              child: Container(
                padding: EdgeInsets.all(Sizes.s10),
                margin: EdgeInsets.all(Sizes.s10),
                child: Icon(
                  FontAwesomeIcons.trash,
                  color: AppColors.primary,
                  size: Sizes.s25,
                ),
              ),
              onTap: onDelete,
            ),
          ),
      ],
    );
  }
}

class AddExperienceWidget extends StatefulWidget {
  final Function(Experience) callBack;
  final Experience experience;

  const AddExperienceWidget({Key key, @required this.callBack, @required this.experience}) : super(key: key);

  @override
  _AddExperienceWidgetState createState() => _AddExperienceWidgetState();
}

class _AddExperienceWidgetState extends State<AddExperienceWidget> {
  Experience _experience = Experience.empty();

  final _formKey = GlobalKey<FormState>();
  List<FocusNode> _focusNodes = List.generate(3, (_) => FocusNode());

  bool rebuild = true;

  @override
  void initState() {
    super.initState();
    _experience = widget.experience;
    appLogs(Screens.RegisterStep4Screen, tag: screenTag);
    Future.delayed(Duration(milliseconds: Constants.delaySmall), () {
      setState(() {
        rebuild = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: Sizes.s20, vertical: Sizes.s80),
        child: Stack(
          children: <Widget>[
            rebuild
                ? LoadingWidget()
                : Form(
                    key: _formKey,
                    child: ListView(
                      padding: EdgeInsets.all(Sizes.s20),
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: FormatDatePickerField(
                                dateFormat: DateFormats.inMonthYear,
                                label: Strings.from,
                                hintText: Strings.from,
                                dateTime: _experience.fromDate,
                                onChange: (DateTime dateTime) {
                                  setState(() {
                                    _experience.fromDate = dateTime;
                                  });
                                },
                              ),
                            ),
                            P5(),
                            Expanded(
                              child: FormatDatePickerField(
                                dateFormat: DateFormats.inMonthYear,
                                label: Strings.to,
                                hintText: Strings.to,
                                dateTime: _experience.toDate,
                                onChange: (DateTime dateTime) {
                                  setState(() {
                                    _experience.toDate = dateTime;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        AppTextFormField(
                          label: Strings.postHeld,
                          hintText: Strings.postHeld,
                          focusNode: _focusNodes[0],
                          validator: AppValidator.validateName,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          onSaved: (value) => _experience.position = value.trim(),
                          onFieldSubmitted: (_) => setFocus(context, focusNode: _focusNodes[1]),
                          initialValue: _experience.position,
                        ),
                        P10(),
                        AppTextFormField(
                          label: Strings.organisationNameLocation,
                          hintText: Strings.organisationNameLocation,
                          focusNode: _focusNodes[1],
                          validator: AppValidator.validateName,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          onSaved: (value) => _experience.organisationName = value.trim(),
                          onFieldSubmitted: (_) => setFocus(context, focusNode: _focusNodes[2]),
                          initialValue: _experience.organisationName,
                        ),
                        P5(),
                        AppTextFormField(
                          label: Strings.descriptionDuties,
                          hintText: Strings.descriptionDuties,
                          focusNode: _focusNodes[2],
                          validator: AppValidator.validateEmptyCheck,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          onSaved: (value) => _experience.description = value.trim(),
                          onFieldSubmitted: (_) => setFocus(context),
                          maxLines: 3,
                          initialValue: _experience.description,
                        ),
                        P5(),
                        AppButton(
                          onTap: () {
                            if (!isFormValid(_formKey)) return;
                            widget.callBack(_experience);
                          },
                          title: Strings.add,
                        ),
                      ],
                    ),
                  ),
            Align(
              alignment: Alignment.topRight,
              child: InkResponse(
                  child: Padding(
                    padding: EdgeInsets.all(Sizes.s10),
                    child: Icon(
                      FontAwesomeIcons.solidWindowClose,
                      color: AppColors.primary,
                      size: Sizes.s25,
                    ),
                  ),
                  onTap: () {
                    AppRoutes.pop(context);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNodes.forEach((_) => _.dispose());
    super.dispose();
  }
}

class ExamWidget extends StatelessWidget {
  final Exam exam;
  final Function onTap;
  final Function onDelete;

  const ExamWidget({Key key, @required this.exam, @required this.onTap, @required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        InkResponse(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.all(Sizes.s6),
            padding: EdgeInsets.all(Sizes.s6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(Sizes.s10)),
              border: Border.all(
                color: AppColors.pinkishGrey,
                width: Sizes.s1,
              ),
              boxShadow: [
                BoxShadow(
                  spreadRadius: -Sizes.s6,
                  blurRadius: Sizes.s15,
                  color: AppColors.pinkishGrey,
                  offset: Offset(Sizes.s2, Sizes.s2),
                )
              ],
            ),
            child: Column(
              children: <Widget>[
                AppTextFormField(
                  label: Strings.examType,
                  hintText: Strings.examType,
                  initialValue: exam.type,
                  enabled: false,
                ),
                FormatDatePickerField(
                  dateFormat: DateFormats.inMonthYear,
                  label: Strings.takenOn,
                  hintText: Strings.takenOn,
                  dateTime: exam.takenOn,
                  enabled: false,
                  onChange: (DateTime date) {},
                ),
                ...exam.subjects
                    .asMap()
                    .map((index, subject) {
                      return MapEntry(
                          index,
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              AppTextFormField(
                                label: subject.title,
                                hintText: subject.title,
                                initialValue: '${subject.marks}',
                                enabled: false,
                              ),
                              P5(),
                            ],
                          ));
                    })
                    .values
                    .toList(),
                P5(),
              ],
            ),
          ),
        ),
        if (onDelete != null)
          Align(
            alignment: Alignment.topRight,
            child: InkResponse(
              child: Container(
                padding: EdgeInsets.all(Sizes.s10),
                margin: EdgeInsets.all(Sizes.s10),
                child: Icon(
                  FontAwesomeIcons.trash,
                  color: AppColors.primary,
                  size: Sizes.s25,
                ),
              ),
              onTap: onDelete,
            ),
          ),
      ],
    );
  }
}

class AddExamWidget extends StatefulWidget {
  final Function(Exam) callBack;
  final Exam exam;

  const AddExamWidget({Key key, @required this.callBack, @required this.exam}) : super(key: key);

  @override
  _AddExamWidgetState createState() => _AddExamWidgetState();
}

class _AddExamWidgetState extends State<AddExamWidget> {
  Exam _exam = Exam.empty();

  final _formKey = GlobalKey<FormState>();
  List<FocusNode> _focusNodes = List.generate(5, (_) => FocusNode());

  bool rebuild = true;

  @override
  void initState() {
    super.initState();
    _exam = widget.exam;
    appLogs(Screens.RegisterStep4Screen, tag: screenTag);
    Future.delayed(Duration(milliseconds: Constants.delaySmall), () {
      setState(() {
        rebuild = false;
      });
    });
  }

  _onExamSelected(String type) {
    _exam = Exam.emptyWithType(type);
    Future.delayed(Duration(milliseconds: Constants.delaySmall), () {
      setState(() {
        rebuild = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: Sizes.s20, vertical: Sizes.s80),
        child: Stack(
          children: <Widget>[
            rebuild
                ? LoadingWidget()
                : Form(
                    key: _formKey,
                    child: ListView(
                      padding: EdgeInsets.all(Sizes.s20),
                      children: <Widget>[
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: Sizes.s10, vertical: Sizes.s10),
                            hintText: Strings.selectExamType,
                            hintStyle: TextStyles.hintStyle,
                            errorStyle: TextStyles.errorStyle,
                            labelStyle: TextStyles.labelStyle,
                            labelText: Strings.selectExamType,
                            errorMaxLines: Constants.errorMaxLines,
                          ),
                          value: _exam.type,
                          items: examType.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyles.editText,
                              ),
                            );
                          }).toList(),
                          onChanged: _onExamSelected,
                        ),
                        FormatDatePickerField(
                          dateFormat: DateFormats.inDayMonthYear,
                          label: Strings.takenOn,
                          hintText: Strings.takenOn,
                          dateTime: _exam.takenOn,
                          onChange: (DateTime dateTime) {
                            setState(() {
                              _exam.takenOn = dateTime;
                            });
                          },
                        ),
                        ..._exam.subjects
                            .asMap()
                            .map((index, subject) {
                              return MapEntry(
                                  index,
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      AppTextFormField(
                                        label: subject.title,
                                        hintText: subject.title,
                                        focusNode: _focusNodes[index],
                                        validator: (value) => AppValidator.validateMarksFields(
                                          label: subject.title + " Marks",
                                          value: value,
                                          max: subject.maxMarks,
                                        ),
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        onSaved: (value) => subject.marks = toDouble(value.trim()),
                                        onFieldSubmitted: (_) => setFocus(context, focusNode: _focusNodes[index + 1]),
                                        initialValue: '${subject.marks == 0 ? "" : subject.marks}',
                                      ),
                                      P10(),
                                    ],
                                  ));
                            })
                            .values
                            .toList(),
                        P5(),
                        AppButton(
                          onTap: () {
                            if (!isFormValid(_formKey)) return;
                            widget.callBack(_exam);
                          },
                          title: Strings.add,
                        ),
                      ],
                    ),
                  ),
            Align(
              alignment: Alignment.topRight,
              child: InkResponse(
                  child: Padding(
                    padding: EdgeInsets.all(Sizes.s10),
                    child: Icon(
                      FontAwesomeIcons.solidWindowClose,
                      color: AppColors.primary,
                      size: Sizes.s25,
                    ),
                  ),
                  onTap: () {
                    AppRoutes.pop(context);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNodes.forEach((_) => _.dispose());
    super.dispose();
  }
}
