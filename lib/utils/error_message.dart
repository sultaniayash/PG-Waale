import 'package:flutter/services.dart';
import 'package:qbix/utils/strings.dart';

class ErrorMessage {
  final String code;
  final String message;
  final String title;

  const ErrorMessage.value({this.code, this.message, this.title});

  toMessage() => '$message';

  toCode() => '$code';

  toTitle() => '$title';

  static String getMessage(String code) {
    switch (code) {
      case 'EMPTY_ROUTE':
        return ErrorMessage.EMPTY_ROUTE.toMessage();
        break;
      case 'INVALID_ROUTE':
        return ErrorMessage.INVALID_ROUTE.toMessage();
        break;
      case 'SOMETHING_WENT_WRONG':
        return ErrorMessage.SOMETHING_WENT_WRONG.toMessage();
        break;
      case 'ERROR_ABORTED_BY_USER':
        return ErrorMessage.ERROR_ABORTED_BY_USER.toMessage();
        break;
      case 'ERROR_WEAK_PASSWORD':
        return ErrorMessage.ERROR_WEAK_PASSWORD.toMessage();
        break;
      case 'EMAIL_NOT_VERIFIED':
        return ErrorMessage.EMAIL_NOT_VERIFIED.toMessage();
        break;
      case 'ERROR_INVALID_CREDENTIAL':
        return ErrorMessage.ERROR_INVALID_CREDENTIAL.toMessage();
        break;
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        return ErrorMessage.ERROR_EMAIL_ALREADY_IN_USE.toMessage();
        break;
      case 'ERROR_INVALID_EMAIL':
        return ErrorMessage.ERROR_INVALID_EMAIL.toMessage();
        break;
      case 'ERROR_WRONG_PASSWORD':
        return ErrorMessage.ERROR_WRONG_PASSWORD.toMessage();
        break;
      case 'ERROR_USER_NOT_FOUND':
        return ErrorMessage.ERROR_USER_NOT_FOUND.toMessage();
        break;
      case 'ERROR_TOO_MANY_REQUESTS':
        return ErrorMessage.ERROR_TOO_MANY_REQUESTS.toMessage();
        break;
      case 'ERROR_TOO_MANY_REQUESTS':
        return ErrorMessage.ERROR_TOO_MANY_REQUESTS.toMessage();
        break;
      case 'ERROR_OPERATION_NOT_ALLOWED':
        return ErrorMessage.ERROR_OPERATION_NOT_ALLOWED.toMessage();
        break;
      case 'NOT_FOUND':
        return ErrorMessage.NOT_FOUND.toMessage();
        break;
      case 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
        return ErrorMessage.ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL.toMessage();
        break;
    }
    return Strings.defaultErrorMessage;
  }

  static String getTitle(String code) {
    switch (code) {
      case 'EMPTY_ROUTE':
        return ErrorMessage.EMPTY_ROUTE.toTitle();
        break;
      case 'INVALID_ROUTE':
        return ErrorMessage.INVALID_ROUTE.toTitle();
        break;
      case 'SOMETHING_WENT_WRONG':
        return ErrorMessage.SOMETHING_WENT_WRONG.toTitle();
        break;
      case 'ERROR_ABORTED_BY_USER':
        return ErrorMessage.ERROR_ABORTED_BY_USER.toTitle();
        break;
      case 'ERROR_WEAK_PASSWORD':
        return ErrorMessage.ERROR_WEAK_PASSWORD.toTitle();
        break;
      case 'EMAIL_NOT_VERIFIED':
        return ErrorMessage.EMAIL_NOT_VERIFIED.toTitle();
        break;
      case 'ERROR_INVALID_CREDENTIAL':
        return ErrorMessage.ERROR_INVALID_CREDENTIAL.toTitle();
        break;
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        return ErrorMessage.ERROR_EMAIL_ALREADY_IN_USE.toTitle();
        break;
      case 'ERROR_INVALID_EMAIL':
        return ErrorMessage.ERROR_INVALID_EMAIL.toTitle();
        break;
      case 'ERROR_WRONG_PASSWORD':
        return ErrorMessage.ERROR_WRONG_PASSWORD.toTitle();
        break;
      case 'ERROR_USER_NOT_FOUND':
        return ErrorMessage.ERROR_USER_NOT_FOUND.toTitle();
        break;
      case 'ERROR_TOO_MANY_REQUESTS':
        return ErrorMessage.ERROR_TOO_MANY_REQUESTS.toTitle();
        break;
      case 'ERROR_TOO_MANY_REQUESTS':
        return ErrorMessage.ERROR_TOO_MANY_REQUESTS.toTitle();
        break;
      case 'ERROR_OPERATION_NOT_ALLOWED':
        return ErrorMessage.ERROR_OPERATION_NOT_ALLOWED.toTitle();
        break;
      case 'NOT_FOUND':
        return ErrorMessage.NOT_FOUND.toTitle();
        break;
      case 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
        return ErrorMessage.ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL.toTitle();
        break;
    }
    return Strings.error;
  }

  factory ErrorMessage.from(exception) {
    if (exception is PlatformException) {
      return ErrorMessage.value(
        code: exception.code,
        message: getMessage(exception.code),
        title: getTitle(exception.code),
      );
    } else {
      return ErrorMessage.value(
        code: "",
        message: Strings.errorMessage,
        title: Strings.error,
      );
    }
  }

  static const NOT_FOUND = const ErrorMessage.value(
    code: 'NOT_FOUND',
    message: 'Not Found',
    title: Strings.error,
  );
  static const EMPTY_ROUTE = const ErrorMessage.value(
    code: 'EMPTY_ROUTE',
    message: 'Please select route!',
    title: Strings.error,
  );
  static const INVALID_ROUTE = const ErrorMessage.value(
    code: 'INVALID_ROUTE',
    message: 'Invalid route!',
    title: Strings.error,
  );
  static const SOMETHING_WENT_WRONG = const ErrorMessage.value(
    code: 'SOMETHING_WENT_WRONG',
    message: 'Something went wrong',
    title: Strings.error,
  );

  static const ERROR_ABORTED_BY_USER = const ErrorMessage.value(
    code: 'ERROR_ABORTED_BY_USER',
    message: 'Aborted by user',
    title: Strings.error,
  );
  static const ERROR_WEAK_PASSWORD = const ErrorMessage.value(
    code: 'ERROR_WEAK_PASSWORD',
    message: 'The password must be 6 characters long or more.',
    title: "Weak Password",
  );
  static const EMAIL_NOT_VERIFIED = const ErrorMessage.value(
    code: 'EMAIL_NOT_VERIFIED',
    message: 'We have sent a verification email. Please verify your email address.',
    title: "Email Not Verified",
  );
  static const ERROR_INVALID_CREDENTIAL = const ErrorMessage.value(
    code: 'ERROR_INVALID_CREDENTIAL',
    message: 'The credentials you have entered is invalid.',
    title: "Invaild Credentials",
  );
  static const ERROR_EMAIL_ALREADY_IN_USE = const ErrorMessage.value(
    code: 'ERROR_EMAIL_ALREADY_IN_USE',
    message: 'Email address is already registered with us. Please use a different email address.',
    title: "Email Already Registered",
  );
  static const ERROR_INVALID_EMAIL = const ErrorMessage.value(
    code: 'ERROR_INVALID_EMAIL',
    message: 'Please enter valid email address.',
    title: "Invalid Email",
  );
  static const ERROR_WRONG_PASSWORD = const ErrorMessage.value(
    code: 'ERROR_WRONG_PASSWORD',
    message: 'Please enter the correct password.',
    title: "Invaild Password",
  );
  static const ERROR_USER_NOT_FOUND = const ErrorMessage.value(
    code: 'ERROR_USER_NOT_FOUND',
    message: 'This user is not present in the system. Please consider signing up.',
    title: "Invalid User",
  );
  static const ERROR_TOO_MANY_REQUESTS = const ErrorMessage.value(
    code: 'ERROR_TOO_MANY_REQUESTS',
    message: 'We have blocked all requests from this device due to unusual activity. Try again later.',
    title: Strings.error,
  );
  static const ERROR_OPERATION_NOT_ALLOWED = const ErrorMessage.value(
    code: 'ERROR_OPERATION_NOT_ALLOWED',
    message: 'This sign in method is not allowed. Please contact support.',
    title: Strings.error,
  );
  static const FIRFirestoreErrorDomain = const ErrorMessage.value(
    code: 'FIRFirestoreErrorDomain',
    message: 'FIRFirestoreErrorDomain',
    title: Strings.error,
  );

  static const ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL = const ErrorMessage.value(
    code: 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL',
    message: 'An account already exists with the same email address but different sign-in credentials',
    title: Strings.error,
  );
  static const Code_7 = const ErrorMessage.value(
    code: 'Code 7',
    message: 'This operation could not be completed due to a server error',
    title: "Alert",
  );
}
