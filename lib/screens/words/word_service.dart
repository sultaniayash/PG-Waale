import 'package:flutter/cupertino.dart';
import 'package:qbix/screens/words/word_model.dart';
import 'package:qbix/services/a_services.dart';
import 'package:qbix/utils/a_utils.dart';
import 'package:qbix/utils/app_constants.dart';
import 'package:qbix/utils/methods.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WordService {
  static String baseUrl = 'https://api.wordnik.com/v4/words.json/wordOfTheDay?api_key=';
  static String apiKey = 'c23b746d074135dc9500c0a61300a3cb7647e53ec2b9b658e';
  static String date = '&date=';

  static Future<WordModel> getTodayWord(BuildContext context) async {
    WordModel wordModel = WordModel.empty();
    final SharedPreferences prefs = await sharedPreferences;

    String todayDate = dateSendFormatter.format(DateTime.now());

    Map data = getMapFromJson(prefs.getString(APIKeys.todayWord + todayDate) ?? "{}");

    wordModel = WordModel.fromMap(data);

    if (wordModel.id.isNotEmpty) {
      appLogs("GET WORD FROM SP");
      return wordModel;
    }

    Map responseData =
        await getDataFromGETAPI(apiName: baseUrl + apiKey + date + todayDate, context: context, useBaseURL: false);

    appLogs("GET WORD FROM API");

    wordModel = WordModel.fromMap(responseData);

    appLogs("SAVE WORD TO SP");

    prefs.setString(APIKeys.todayWord + todayDate, getJsonFromMap(wordModel.toMap()));

    return wordModel;
  }
}
