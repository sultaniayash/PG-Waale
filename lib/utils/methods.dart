import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:crossplat_objectid/crossplat_objectid.dart' as crossplat_objectid;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:qbix/app_config.dart';
import 'package:qbix/components/alert_component.dart';
import 'package:qbix/services/a_services.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';

import 'error_message.dart';

appLogs(Object object, {String tag = 'APPLOGS'}) {
  if (App.appLog) {
    String message = "$object";

    int maxLogSize = 1000;
    for (int i = 0; i <= message.length / maxLogSize; i++) {
      int start = i * maxLogSize;
      int end = (i + 1) * maxLogSize;
      end = end > message.length ? message.length : end;
      print("$tag : ${message.substring(start, end)}");
    }
  }
}

apiLogs(Object object, {String tag = 'API'}) {
  if (App.apiLog) {
    String message = "$object";

    int maxLogSize = 1000;
    for (int i = 0; i <= message.length / maxLogSize; i++) {
      int start = i * maxLogSize;
      int end = (i + 1) * maxLogSize;
      end = end > message.length ? message.length : end;
      print("$tag : ${message.substring(start, end)}");
    }
  }
}

setFocus(BuildContext context, {FocusNode focusNode}) {
  FocusScope.of(context).requestFocus(focusNode ?? FocusNode());
}

showSnackBar({
  @required String title,
  @required GlobalKey<ScaffoldState> scaffoldKey,
  Color color,
  int milliseconds = Constants.delayXXL,
  TextStyle style,
}) {
  scaffoldKey.currentState?.showSnackBar(
    new SnackBar(
      backgroundColor: color ?? AppColors.primary,
      duration: Duration(milliseconds: milliseconds),
      content: Container(
        constraints: BoxConstraints(minHeight: Sizes.snackBarHeight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(
              title,
              style: style ?? TextStyles.snackBarText,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

Future<bool> isConnected() async {
  DateTime start = new DateTime.now();
  var connectivityResult = await (new Connectivity().checkConnectivity());
  bool result = false;
  if (connectivityResult != ConnectivityResult.none) result = true;
  if (result) {
    Response response = await Dio().get("https://google.com");
    result = response.statusCode == 200;
  }
  DateTime end = new DateTime.now();
  appLogs("isConnected time taken: ${end.difference(start).inMilliseconds} inMilliseconds");
  return result;
}

Future<Null> performIfConnected(
    {@required Function onConnected, Function onNotConnected, bool showMessage = true}) async {
  appLogs("performIfConnected ------>Called ");
  if (await isConnected()) {
    appLogs("performIfConnected ------>Connected----->callBack called ");
    await onConnected();
  } else {
    if (showMessage) AppToast.showMessage(Strings.notConnected);
    await onNotConnected();
  }
}

bool isFormValid(key) {
  final form = key.currentState;
  if (form.validate()) {
    form.save();
    appLogs('$key isFormValid:true');

    return true;
  }
  appLogs('$key isFormValid:false');

  return false;
}

String getJsonFromMap(Map mapData) {
  String data = "";

  try {
    data = json.encode(mapData);
  } catch (e, s) {
    appLogs("Error in getJsonFromMap\n\n *$mapData* \n\n $e\n\n$s");
  }

  return data;
}

Map getMapFromJson(String mapData) {
  Map data = Map();

  try {
    if (mapData.isEmpty) return data;
    data = json.decode(mapData);
  } catch (e, s) {
    appLogs("Error in getMapFromJson\n\n *$mapData* \n\n $e\n\n$s");
  }

  return data;
}

int toINT(Object value) {
  if (value != null) {
    try {
      int number = int.tryParse('$value');
      return number;
    } on Exception catch (e, s) {
      appLogs("toINT Exception : $e\n$s");

      return 0;
    }
  }
  return 0;
}

double toDouble(Object value) {
  if (value != null) {
    try {
      double number = double.tryParse('$value') ?? 0.0;
      return number;
    } on Exception catch (e, s) {
      appLogs("toDouble Exception : $e\n$s");
      return 0;
    }
  }
  return 0;
}

callNumber(BuildContext context, {@required String userMobileNumber}) async {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => CupertinoActionSheet(
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text(
            'Call $userMobileNumber',
            style: TextStyles.defaultBold.copyWith(
              color: Colors.blue,
              fontSize: FontSize.s20,
            ),
          ),
          onPressed: () async {
            AppRoutes.pop(context);
            String url = "tel:$userMobileNumber";
            await launchURL(url);
          },
          isDefaultAction: true,
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          'Cancel',
          style: TextStyles.defaultSemiBold.copyWith(color: Colors.red),
        ),
        onPressed: () async {
          AppRoutes.pop(context);
        },
        isDestructiveAction: true,
      ),
    ),
  );
}

sendEmail(String email) async {
  String url = "mailto:$email";
  await launchURL(url);
}

DateTime toDateTimeFromString(String value) {
  apiLogs("toDateTimeFromString value is $value");
  DateTime tempDateTime = DateTime.now().subtract(Duration(days: 1));

  try {
    if (value == null) {
      return DateTime.now();
    } else {
      value = value.toString().replaceAll("/", "-");
    }
    tempDateTime = DateTime.tryParse(value);
  } catch (e, s) {
    appLogs("Error in toDateTimeFromString ${e.toString()}\n$s");
    return tempDateTime;
  }

  apiLogs("toDateTimeFromString ${tempDateTime.toString()}");

  return tempDateTime;
}

addIfNotEmpty({
  @required String key,
  @required String value,
  @required Map<String, dynamic> parameterData,
}) {
  if (value.isNotEmpty) {
    parameterData.putIfAbsent(key, () => value);
  }
}

String getDateText(DateTime dateTime, {bool withYear = false}) {
  DateTime now = DateTime.now();
  if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day) return "Today";
  if (withYear) return dateDOBFormatter.format(dateTime);
  return dayMonthFormatter.format(dateTime);
}

handelException(BuildContext context, e, s, String title) {
  appLogs("$title $e\n$s");
  if (e is PlatformException) {
    ErrorMessage errorMessage = ErrorMessage.from(e);
    showAlert(
      context: context,
      message: errorMessage.message,
      title: errorMessage.title,
    );
  } else {
    AppToast.showMessage(Strings.defaultErrorMessage);
  }
}

String getCurrentTime() {
  return serverDateTimeFormatter.format(DateTime.now());
}

String formatDateFromString({
  @required DateFormat formatter,
  @required String value,
}) {
  try {
    DateTime tempDateTime = toDateTimeFromString(value);

    return formatter.format(tempDateTime);
  } catch (e, s) {
    appLogs(" formatDateFromString-->   $value : $e\n$s");
  }
  return "NA";
}

String formatDateFromDateTime({
  @required DateFormat formatter,
  @required DateTime value,
}) {
  try {
    return formatter.format(value);
  } catch (e, s) {
    appLogs(" formatDateFromString-->   $value : $e\n$s");
  }
  return "NA";
}

String generateDbId() {
  return crossplat_objectid.ObjectId().toHexString();
}
