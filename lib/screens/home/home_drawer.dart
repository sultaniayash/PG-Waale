import 'package:flutter/material.dart';
import 'package:qbix/app_config.dart';
import 'package:qbix/components/app_components.dart';
import 'package:qbix/screens/appointment/view_appointmetn_screen.dart';
import 'package:qbix/screens/data_bank/data_bank_screen.dart';
import 'package:qbix/screens/events/event_list_screen.dart';
import 'package:qbix/screens/login/login_screen.dart';
import 'package:qbix/screens/profile/profile_screen.dart';
import 'package:qbix/screens/queiries/queies_screen.dart';
import 'package:qbix/screens/task/task_list_screen.dart';
import 'package:qbix/services/auth_service.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HomeDrawer({Key key, this.scaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    closeDrawer() {
      if (scaffoldKey.currentState.isDrawerOpen) AppRoutes.pop(context);
    }

    return Drawer(
      child: Column(
        children: <Widget>[
          Flexible(
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      P20(),
                      Text(
                        auth.currentUser.personalInformation.firstName,
                        style: TextStyles.defaultSemiBold.copyWith(
                          fontSize: FontSize.s30,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      C5(),
                      Text(
                        auth.currentUser.emailId,
                        style: TextStyles.defaultItalic.copyWith(
                          fontSize: FontSize.s20,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                  ),
                ),
                ListTile(
                  title: Row(
                    children: <Widget>[
                      ImageIcon(
                        AssetImage(Assets.Calendar),
                        size: Sizes.s30,
                        color: AppColors.primary,
                      ),
                      C10(),
                      Expanded(
                          child: Text(
                        Strings.appointments,
                        style: TextStyles.drawerItem,
                      )),
                    ],
                  ),
                  onTap: () {
                    closeDrawer();
                    AppRoutes.push(context, ViewAppointmentScreen());
                  },
                ),
                ListTile(
                  title: Row(
                    children: <Widget>[
                      ImageIcon(
                        AssetImage(Assets.Tasks),
                        size: Sizes.s30,
                        color: AppColors.primary,
                      ),
                      C10(),
                      Expanded(
                          child: Text(
                        Strings.tasks,
                        style: TextStyles.drawerItem,
                      )),
                    ],
                  ),
                  onTap: () {
                    closeDrawer();
                    AppRoutes.push(context, TaskListScreen());
                  },
                ),
                ListTile(
                  title: Row(
                    children: <Widget>[
                      ImageIcon(
                        AssetImage(Assets.Events),
                        size: Sizes.s30,
                        color: AppColors.primary,
                      ),
                      C10(),
                      Expanded(
                          child: Text(
                        Strings.events,
                        style: TextStyles.drawerItem,
                      )),
                    ],
                  ),
                  onTap: () {
                    closeDrawer();
                    AppRoutes.push(context, EventListScreen());
                  },
                ),
                ListTile(
                  title: Row(
                    children: <Widget>[
                      ImageIcon(
                        AssetImage(Assets.Queries),
                        size: Sizes.s30,
                        color: AppColors.primary,
                      ),
                      C10(),
                      Expanded(
                          child: Text(
                        Strings.queries,
                        style: TextStyles.drawerItem,
                      )),
                    ],
                  ),
                  onTap: () {
                    closeDrawer();
                    AppRoutes.push(context, QueriesScreen());
                  },
                ),
                ListTile(
                  title: Row(
                    children: <Widget>[
                      ImageIcon(
                        AssetImage(Assets.DataBank),
                        size: Sizes.s30,
                        color: AppColors.primary,
                      ),
                      C10(),
                      Expanded(
                          child: Text(
                        Strings.dataBank,
                        style: TextStyles.drawerItem,
                      )),
                    ],
                  ),
                  onTap: () {
                    closeDrawer();
                    AppRoutes.push(context, DataBankScreen());
                  },
                ),
                ListTile(
                  title: Row(
                    children: <Widget>[
                      ImageIcon(
                        AssetImage(Assets.Account),
                        size: Sizes.s30,
                        color: AppColors.primary,
                      ),
                      C10(),
                      Expanded(
                          child: Text(
                        'PROFILE',
                        style: TextStyles.drawerItem,
                      )),
                    ],
                  ),
                  onTap: () {
                    closeDrawer();
                    AppRoutes.push(context, ProfileScreen(user: auth.currentUser));
                  },
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () async {
              showAlertWithTwoOption(
                image: Assets.QbixLogo,
                context: context,
                message: "Do you want to logout ?",
                title: "LOGOUT",
                positiveButtonOnTap: () async {
                  final SharedPreferences prefs = await sharedPreferences;
                  await prefs.clear();
                  AppRoutes.makeFirst(context, LoginScreen());
                },
                negativeButtonOnTap: () {},
              );
            },
          ),
          ListTile(
            title: Text("Share"),
            subtitle: Text("${App.appName} ${App.versionName} "),
            onTap: () {
              String shareText = "${App.appName}\n\n";
              shareText += "Android :  ${App.androidURL}\n\n";
              shareText += "Iphone :  ${App.iosURL}";
              Share.share(shareText);
            },
          ),
        ],
      ),
    );
  }
}
