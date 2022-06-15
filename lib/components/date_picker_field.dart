import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';

class DatePickerField extends StatelessWidget {
  final Function(DateTime) onChange;
  final DateTime dateTime;
  final DateTime firstDate;
  final DateTime lastDate;
  final String label;
  final String hintText;
  final bool enabled;

  const DatePickerField({
    Key key,
    @required this.onChange,
    @required this.label,
    @required this.hintText,
    @required this.dateTime,
    this.enabled = true,
    @required this.firstDate,
    @required this.lastDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () async {
        if (!enabled) return;
        DateTime selectedDateTime = await showDatePicker(
          initialDatePickerMode: DatePickerMode.year,
          context: context,
          initialDate: dateTime,
          firstDate: firstDate,
          lastDate: lastDate,
        );

        if (selectedDateTime != null) onChange(selectedDateTime);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: Sizes.s10, vertical: Sizes.s10),
          hintText: hintText,
          hintStyle: TextStyles.hintStyle,
          errorStyle: TextStyles.errorStyle,
          labelStyle: TextStyles.labelStyle,
          labelText: label,
          errorMaxLines: Constants.errorMaxLines,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: Sizes.s5),
          child: Row(
            children: <Widget>[
              Icon(
                FontAwesomeIcons.calendar,
                color: Colors.grey.shade500,
              ),
              C10(),
              Expanded(
                child: Text(
                  dateDOBFormatter.format(dateTime),
                  style: TextStyles.editText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FormatDatePickerField extends StatelessWidget {
  final Function(DateTime) onChange;
  final DateTime dateTime;
  final String label;
  final String hintText;
  final String dateFormat;
  final bool enabled;

  const FormatDatePickerField({
    Key key,
    @required this.onChange,
    @required this.label,
    @required this.hintText,
    @required this.dateTime,
    @required this.dateFormat,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: enabled
          ? () async {
              DatePicker.showDatePicker(
                context,
                dateFormat: dateFormat,
                onChange: (DateTime dateTime, List<int> selectedIndex) {
                  onChange(dateTime);
                },
              );
            }
          : null,
      child: InputDecorator(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: Sizes.s10, vertical: Sizes.s10),
          hintText: hintText,
          hintStyle: TextStyles.hintStyle,
          errorStyle: TextStyles.errorStyle,
          labelStyle: TextStyles.labelStyle,
          labelText: label,
          errorMaxLines: Constants.errorMaxLines,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: Sizes.s5),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  DateFormat(dateFormat).format(dateTime),
                  style: TextStyles.editText,
                ),
              ),
              C10(),
              if (enabled)
                Icon(
                  FontAwesomeIcons.chevronDown,
                  size: Sizes.s10,
                  color: Colors.grey.shade500,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
