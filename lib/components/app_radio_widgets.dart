import 'package:flutter/material.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';

class GenderRadioWidget extends StatelessWidget {
  final Function(String) onChange;
  final String gender;
  final String label;
  final String hintText;

  const GenderRadioWidget({
    Key key,
    @required this.onChange,
    @required this.label,
    @required this.hintText,
    @required this.gender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RadioWidget(
              data: genderList[0],
              isActive: gender == genderList[0],
              onChange: onChange,
            ),
            RadioWidget(
              data: genderList[1],
              isActive: gender == genderList[1],
              onChange: onChange,
            ),
            RadioWidget(
              data: genderList[2],
              isActive: gender == genderList[2],
              onChange: onChange,
            ),
          ],
        ),
      ),
    );
  }
}

class EducationTypeRadioWidget extends StatelessWidget {
  final Function(String) onChange;
  final String type;

  const EducationTypeRadioWidget({
    Key key,
    @required this.onChange,
    @required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Sizes.s5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          RadioWidget(
            data: educationTypeList[0],
            isActive: type == educationTypeList[0],
            onChange: onChange,
          ),
          P10(),
          RadioWidget(
            data: educationTypeList[1],
            isActive: type == educationTypeList[1],
            onChange: onChange,
          ),
        ],
      ),
    );
  }
}

class RadioWidget extends StatelessWidget {
  final Function(String) onChange;
  final String data;
  final bool isActive;

  const RadioWidget({
    Key key,
    @required this.onChange,
    @required this.data,
    @required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () {
        onChange(data);
      },
      child: Container(
        padding: EdgeInsets.all(Sizes.s5),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: Sizes.s8,
              backgroundColor: isActive ? AppColors.primary : Colors.grey.shade500,
            ),
            C5(),
            Text(
              data,
              style: TextStyles.editText.copyWith(
                color: isActive ? Colors.black : Colors.grey.shade500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
