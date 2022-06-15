import 'package:flutter/material.dart';
import 'package:qbix/utils/a_utils.dart';

class AppValidator {
  static String validateEmail(String value) {
    appLogs("validateEmail : $value ");

    if (value.isEmpty) return Strings.enterEmail;

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regex = new RegExp(pattern);

    if (!regex.hasMatch(value.trim())) {
      return Strings.enterValidEmail;
    }

    return null;
  }

  static String validateName(String value) {
    appLogs("validateName : $value ");

    if (value.isEmpty) return Strings.enterName;

    RegExp regex = new RegExp('[a-zA-Z]');

    if (!regex.hasMatch(value.trim())) {
      return Strings.enterValidName;
    }

    return null;
  }

  static String validatePhone(String value) {
    if (value.isEmpty) return Strings.enterPhone;

    if (value.contains("/") || value.contains(".") || value.contains(",")) {
      return Strings.enterValidPhone;
    }
    if (value.length < 10) {
      return Strings.enterValidPhone;
    }

    return null;
  }

  static String validatePassword(String value) {
    appLogs("validatePassword : $value ");
    if (value.isEmpty) return Strings.enterPassword;
    Pattern pattern = r'[A-Za-z0-9@#$%^&+=]{6,}';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value.trim())) {
      return Strings.passwordValidationMsg;
    }
    return null;
  }

  static String validateOTP(String value) {
    if (value.isEmpty) return Strings.enterOTP;

    if (value.length < 6) {
      return Strings.enterValidOTP;
    }

    return null;
  }

  static String validateEmptyCheck(String value) {
    if (value.isEmpty) return Strings.emptyMessage;
    return null;
  }

  static String validateMarksFields({
    String label,
    String value,
    @required double max,
    bool required = true,
  }) {
    if (value.isEmpty && required) return "Enter $label !";

    if (value.isEmpty) return null;

    if (toDouble(value) > max) {
      return "Enter valid $label [Max : $max]";
    }

    return null;
  }
}
