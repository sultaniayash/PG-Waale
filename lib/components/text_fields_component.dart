import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';

class AppTextFormField extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final String label;
  final String hintText;
  final String prefixText;
  final String initialValue;
  final int maxLength;
  final int maxLines;
  final TextInputType keyboardType;
  final bool enabled;
  final bool active;
  final bool isRequired;
  final bool obscureText;
  final bool isNumber;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final ValueChanged<String> onFieldSubmitted;
  final TextEditingController controller;

  const AppTextFormField({
    Key key,
    this.controller,
    this.onSaved,
    this.validator,
    this.label = "",
    this.hintText = "",
    this.prefixText,
    this.maxLength,
    this.active = false,
    this.keyboardType,
    this.enabled = true,
    this.isRequired = false,
    this.isNumber = false,
    this.obscureText = false,
    this.initialValue,
    this.focusNode,
    this.maxLines = 1,
    this.onFieldSubmitted,
    this.textInputAction = TextInputAction.done,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: Sizes.s10, vertical: Sizes.s10),
          hintText: hintText,
          hintStyle: TextStyles.hintStyle,
          errorStyle: TextStyles.errorStyle,
          prefixText: prefixText,
          labelStyle: TextStyles.labelStyle,
          labelText: label,
          errorMaxLines: Constants.errorMaxLines,
        ),
        inputFormatters: (maxLength != null)
            ? isNumber
                ? [LengthLimitingTextInputFormatter(maxLength), WhitelistingTextInputFormatter(RegExp("[0-9]"))]
                : [LengthLimitingTextInputFormatter(maxLength)]
            : [],
        onSaved: onSaved,
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
        keyboardType: keyboardType,
        enabled: enabled,
        initialValue: initialValue,
        textInputAction: textInputAction,
        style: TextStyles.editText,
        obscureText: obscureText,
        maxLines: maxLines,
        textCapitalization: TextCapitalization.sentences,
      ),
    );
  }
}
