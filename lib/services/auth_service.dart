import 'package:flutter/cupertino.dart';
import 'package:qbix/models/app_models.dart';
import 'package:qbix/models/master_data_model.dart';
import 'package:qbix/screens/appointment/appointment_select_counsellor_screen.dart';
import 'package:qbix/screens/home/home_screen.dart';
import 'package:qbix/screens/login/login_screen.dart';
import 'package:qbix/screens/register_setps/register_step_1_screen.dart';
import 'package:qbix/utils/a_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_service.dart';

final auth = new Auth();

class Auth {
  User currentUser;

  Auth() {
    currentUser = User.empty();
  }

  Future<Null> setUserFromSharedPreference() async {
    final SharedPreferences prefs = await sharedPreferences;
    appLogs("setUserFromPreference");
    auth.currentUser = User.fromMap(
      loggedIn: prefs.getBool(APIKeys.loggedIn) ?? false,
      data: getMapFromJson(prefs.getString(APIKeys.userData) ?? "{}"),
    );
    auth.currentUser.log();
  }

  Future<Null> updateUserInSharedPreference(User user) async {
    appLogs("updateUserInSharedPrefs");
    auth.currentUser = user;
    final SharedPreferences prefs = await sharedPreferences;
    prefs.setBool(APIKeys.loggedIn, user.loggedIn ?? false);
    prefs.setString(APIKeys.userData, getJsonFromMap(user.toMap()));
    user.log();
  }

  static Future<Null> redirectUserAsPerStatus(BuildContext context) async {
    appLogs("redirectUserAsPerStatus");

    await MasterData.fetchMasterData();

    if (auth.currentUser.loggedIn) {
      bool isInfoComplete = await FirebaseSignIn.checkIsInfoComplete();
      if (!isInfoComplete) {
        AppRoutes.makeFirst(context, RegisterStep1Screen());
      } else {
        Map data = await FirebaseRepo.getFirstAppointmentData();
        if (data.isEmpty) {
          AppRoutes.makeFirst(context, AppointmentSelectCounsellorScreen(isFirstAppointment: true));
        } else {
          AppRoutes.makeFirst(context, HomeScreen());
        }
      }
    } else {
      AppRoutes.makeFirst(context, LoginScreen());
    }
  }
}
