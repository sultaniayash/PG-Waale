import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:flutter/material.dart';
import 'package:qbix/components/app_components.dart';
import 'package:qbix/models/counsellor_model.dart';
import 'package:qbix/services/a_services.dart';
import 'package:qbix/theme/app_colors.dart';
import 'package:qbix/theme/textstyles.dart';
import 'package:qbix/utils/a_utils.dart';
import 'package:qbix/widgets/counsellor_widget.dart';

import 'appointment_select_time_slot_screen.dart';

class SelectCounsellorScreen extends StatefulWidget {
  const SelectCounsellorScreen({
    Key key,
  }) : super(key: key);

  @override
  _FirstSelectCounsellorScreenState createState() => _FirstSelectCounsellorScreenState();
}

class _FirstSelectCounsellorScreenState extends State<SelectCounsellorScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageState _pageState = PageState.LOADED;

  @override
  void initState() {
    super.initState();
    appLogs(Screens.SelectCounsellorScreen, tag: screenTag);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.white,
      appBar: appBarCustom(
        title: Strings.bookAppointment,
      ),
      body: Stack(
        children: <Widget>[
          getBody(),
          ScreenLoader(pageState: _pageState),
        ],
      ),
    );
  }

  Widget getBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        P10(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Sizes.s40),
          child: Text(
            Strings.scheduleAppointmentMessage,
            style: TextStyles.defaultSemiBold.copyWith(
              fontSize: Sizes.s12,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        P10(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Sizes.s40),
          child: Text(
            Strings.selectCounsellor,
            style: TextStyles.defaultSemiBold,
            textAlign: TextAlign.left,
          ),
        ),
        C10(),
        Flexible(
          child: FirestoreAnimatedList(
            padding: EdgeInsets.symmetric(horizontal: Sizes.s40, vertical: Sizes.s10),
            query: FirebaseRepo.getAllCounsellors(),
            itemBuilder: (BuildContext context, DocumentSnapshot snapshot, Animation animation, int index) {
              Counsellor counsellor = Counsellor.fromMap(snapshot.data);
              return CounsellorWidget(
                counsellor: counsellor,
                onTap: () async {
                  AppRoutes.push(
                      context,
                      AppointmentSelectTimeSlotScreen(
                        counsellor: counsellor,
                        previousAppointment: null,
                        isFirstAppointment: false,
                      ));
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
