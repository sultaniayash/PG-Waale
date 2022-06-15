import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:qbix/utils/a_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class API {
  static String baseURL = "https://invoiceapp.xyz";

  //  API NAMES
  static String login = "/api/login";
}

String getFileName(String filePath) {
  return basename(filePath);
}

Map<String, String> requestHeaders = {
  'Content-type': 'application/json',
  'Accept': 'application/json',
};

Future<Map<String, dynamic>> getDataFromPOSTAPI({
  @required String apiName,
  @required Map<String, dynamic> parameterData,
  @required BuildContext context,
  File file,
  bool popAfter = false,
  bool logEnabled = true,
}) async {
  Map<String, dynamic> responseData = new Map();

  String url = API.baseURL + apiName;

  bool errorFlag = false;
  bool timeOutFlag = false;

  if (logEnabled) apiLogs("getDataFromPOSTAPI : $apiName with URL = $url");
  if (logEnabled) {
    apiLogs("getDataFromPOSTAPI : $apiName with Request");
    parameterData.forEach((k, v) {
      apiLogs('$k : $v');
    });
  }

  try {
    FormData formData = new FormData.from(parameterData);
    if (file != null)
      formData.add(
        "image",
        UploadFileInfo(file, getFileName(file.path)),
      );

    Dio dio = new Dio();

    await dio
        .post(Uri.encodeFull(url),
            data: formData,
            options: Options(
                headers: requestHeaders,
                validateStatus: (status) {
                  return status < serverErrorCode;
                }))
        .catchError((onError) {
      if (logEnabled) apiLogs("getDataFromPOSTAPI : $apiName has Error $onError");

      errorFlag = true;
    }).timeout(new Duration(seconds: timeOutSecond), onTimeout: () async {
      if (logEnabled) apiLogs("getDataFromPOSTAPI : $apiName has TimeOut");

      timeOutFlag = true;

      return null;
    }).then((response) {
      if (response != null && !timeOutFlag && !errorFlag) {
        if (logEnabled) apiLogs("getDataFromPOSTAPI : $apiName has Response :${response.toString()}");
        if (logEnabled) apiLogs("getDataFromPOSTAPI : $apiName has Response statusCode:${response.statusCode}");
        if (logEnabled) apiLogs("getDataFromPOSTAPI : $apiName has Response body:${response.data}");
        try {
          responseData = response.data;
        } on Exception catch (e, s) {
          if (logEnabled) apiLogs("getDataFromPOSTAPI : $apiName has Response Exception:$e \n $s");
        }
        responseData.putIfAbsent("statusCode", () => response.statusCode);
      }
    });
  } catch (exception, stackTrace) {
    if (logEnabled) apiLogs(exception);
    if (logEnabled) apiLogs(stackTrace);
  }

  if (popAfter) {
    AppRoutes.pop(context);
    if (logEnabled) apiLogs("getDataFromPOSTAPI : popAfter $popAfter");
  } else {
    if (logEnabled) apiLogs("getDataFromPOSTAPI : popAfter $popAfter");
  }

  if (errorFlag) {
    if (logEnabled) apiLogs("getDataFromPOSTAPI : $apiName Show Error");

    responseData.clear();

    responseData.putIfAbsent("statusCode", () => errorStatusCode);
    responseData.putIfAbsent("message", () => Strings.defaultErrorMessage);
  } else if (timeOutFlag) {
    if (logEnabled) apiLogs("getDataFromPOSTAPI : $apiName Show TimeOut  $timeOutFlag");

    responseData.clear();

    responseData.putIfAbsent("statusCode", () => timeOutCode);
    responseData.putIfAbsent("message", () => Strings.timeOutMessage);
  }

  if (logEnabled) apiLogs("getDataFromPOSTAPI : $apiName has Response: " + responseData.toString());

  return responseData;
}

Future<Map<String, dynamic>> getDataFromGETAPI({
  @required String apiName,
  @required BuildContext context,
  bool useBaseURL = true,
  bool logEnabled = true,
}) async {
  Map<String, dynamic> responseData = new Map();

  String url = useBaseURL ? (API.baseURL + apiName) : apiName;

  bool errorFlag = false;
  bool timeOutFlag = false;

  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  if (logEnabled) apiLogs("getDataFromGETAPI : $apiName with URL = $url");
  if (logEnabled) apiLogs("getDataFromGETAPI : $requestHeaders with requestHeaders  = $requestHeaders");

  try {
    Dio dio = new Dio();

    await dio
        .get(
      Uri.encodeFull(url),
      options: Options(
          headers: requestHeaders,
          validateStatus: (status) {
            return status < serverErrorCode;
          }),
    )
        .catchError((onError) {
      if (logEnabled) apiLogs("getDataFromGETAPI : $apiName has Error");

      errorFlag = true;
    }).timeout(new Duration(seconds: timeOutSecond), onTimeout: () async {
      if (logEnabled) apiLogs("getDataFromGETAPI : $apiName has TimeOut ");
      timeOutFlag = true;
      return null;
    }).then((response) {
      if (response != null && !timeOutFlag && !errorFlag) {
        if (logEnabled) apiLogs("getDataFromPATCHAPI : $apiName has Response statusCode:${response.statusCode}");
        if (logEnabled) apiLogs("getDataFromPATCHAPI : $apiName has Response body:${response.data}");
        try {
          responseData = response.data;
        } catch (e, s) {
          if (logEnabled) apiLogs("getDataFromPATCHAPI : $apiName has Response Exception:$e \n $s");
          responseData = Map();
        }
        responseData.putIfAbsent("statusCode", () => response.statusCode);
      }
    });
  } catch (exception, stackTrace) {
    if (logEnabled) apiLogs(exception);
    if (logEnabled) apiLogs(stackTrace);
  }

  if (errorFlag) {
    if (logEnabled) apiLogs("getDataFromGETAPI : $apiName Show Error");

    responseData.clear();

    responseData.putIfAbsent("statusCode", () => errorStatusCode);
    responseData.putIfAbsent("message", () => Strings.defaultErrorMessage);
  } else if (timeOutFlag) {
    if (logEnabled) apiLogs("getDataFromGETAPI : $apiName Show TimeOut $timeOutFlag");

    responseData.clear();

    responseData.putIfAbsent("statusCode", () => timeOutCode);
    responseData.putIfAbsent("message", () => Strings.timeOutMessage);
  }

  return responseData;
}

Future<Null> launchURL(String url) async {
  try {
    url = Uri.encodeFull(url);
    apiLogs('\n\nURL: $url \n\n');
    await launch(url.toString(), forceSafariVC: false, forceWebView: false);
  } catch (e) {
    apiLogs('\n\nError in launchURL: $e\n\n');
  }
}
