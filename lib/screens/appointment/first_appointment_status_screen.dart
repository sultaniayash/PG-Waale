import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:qbix/components/buttons_component.dart';
import 'package:qbix/components/custom_appbar_component.dart';
import 'package:qbix/models/appointment_models.dart';
import 'package:qbix/screens/home/home_screen.dart';
import 'package:qbix/services/a_services.dart';
import 'package:qbix/theme/app_colors.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';

import 'appointment_widget.dart';

class FirstAppointmentStatusScreen extends StatefulWidget {
  final Appointment appointment;

  const FirstAppointmentStatusScreen({Key key, @required this.appointment}) : super(key: key);

  @override
  _FirstAppointmentStatusScreenState createState() => _FirstAppointmentStatusScreenState();
}

class _FirstAppointmentStatusScreenState extends State<FirstAppointmentStatusScreen>
    with AfterLayoutMixin<FirstAppointmentStatusScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageState _pageState = PageState.LOADING;

  @override
  void initState() {
    super.initState();
    appLogs(Screens.FirstAppointmentStatusScreen, tag: screenTag);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _onLoad();

    Map data = auth.currentUser.toMap();

    appLogs(data);
  }

  @override
  void dispose() {
    super.dispose();
  }

  _showLoading() {
    appLogs("FirstAppointmentStatusScreen:_hideLoading");
    setState(() => _pageState = PageState.LOADING);
  }

  _hideLoading() {
    appLogs("FirstAppointmentStatusScreen:_hideLoading");
    setState(() => _pageState = PageState.LOADED);
  }

  _onLoad() async {
    appLogs("FirstAppointmentStatusScreen:_onLoad");
    _hideLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarCustom(
        title: Strings.appointmentConfirmed,
        backgroundColor: Colors.transparent,
        style: TextStyles.appBarTittle.copyWith(
          color: Colors.grey.shade600,
        ),
        leading: C0(),
      ),
      backgroundColor: AppColors.white,
      body: Stack(
        children: <Widget>[
          getBody(),
          ScreenLoader(pageState: _pageState),
        ],
      ),
    );
  }

  Widget getBody() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: Sizes.s40),
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: Sizes.s40),
          child: Image(
            height: Sizes.screenWidthHalf * 0.8,
            image: AssetImage(
              Assets.AppointmentConfirmed,
            ),
            fit: BoxFit.contain,
          ),
        ),
        Text(
          Strings.appointmentConfirmedSuccess,
          style: TextStyles.defaultSemiBold,
          textAlign: TextAlign.center,
        ),
        P10(),
        if (widget.appointment.from.isNotEmpty)
          AppointmentStatusWidget(
            status: AppointmentStatus.RESCHEDULED,
          ),
        if (widget.appointment.from.isNotEmpty) P10(),
        Text(
          "${widget.appointment.timeSlot.startTime} - ${widget.appointment.timeSlot.endTime}",
          style: TextStyles.defaultSemiBold.copyWith(
            fontSize: FontSize.s24,
          ),
          textAlign: TextAlign.center,
        ),
        C10(),
        Text(
          "${dateDOBFormatter.format(toDateTimeFromString(widget.appointment.date))}",
          style: TextStyles.defaultSemiBold.copyWith(
            fontSize: FontSize.s24,
          ),
          textAlign: TextAlign.center,
        ),
        P10(),
        Text(
          Strings.QBIXAddress,
          style: TextStyles.defaultSemiBold.copyWith(
            fontSize: Sizes.s12,
            color: Colors.grey.shade500,
          ),
          textAlign: TextAlign.center,
        ),
        P10(),
        InkResponse(
          onTap: () {
            launchURL(Strings.QBIXGoogleMap);
          },
          child: Container(
            child: Image(
              height: Sizes.s150,
              image: AssetImage(
                Assets.Map,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        P10(),
        AppButton(
          onTap: () async {
            _showLoading();
            await FirebaseSignIn.updateUserData();
            _hideLoading();
            AppRoutes.makeFirst(context, HomeScreen());
          },
          title: Strings.Continue,
        ),
        C10(),
      ],
    );
  }
}
