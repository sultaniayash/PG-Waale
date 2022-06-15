import 'package:after_layout/after_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qbix/components/alert_component.dart';
import 'package:qbix/components/buttons_component.dart';
import 'package:qbix/components/custom_appbar_component.dart';
import 'package:qbix/models/appointment_models.dart';
import 'package:qbix/models/counsellor_model.dart';
import 'package:qbix/models/time_slot_model.dart';
import 'package:qbix/services/a_services.dart';
import 'package:qbix/theme/app_colors.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';
import 'package:qbix/widgets/counsellor_widget.dart';

import 'appointment_widget.dart';
import 'first_appointment_status_screen.dart';

class AppointmentSelectTimeSlotScreen extends StatefulWidget {
  final Counsellor counsellor;
  final Appointment previousAppointment;
  final bool isFirstAppointment;

  const AppointmentSelectTimeSlotScreen({
    Key key,
    @required this.counsellor,
    this.previousAppointment,
    @required this.isFirstAppointment,
  }) : super(key: key);

  @override
  _AppointmentSelectTimeSlotScreenState createState() => _AppointmentSelectTimeSlotScreenState();
}

class _AppointmentSelectTimeSlotScreenState extends State<AppointmentSelectTimeSlotScreen>
    with AfterLayoutMixin<AppointmentSelectTimeSlotScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageState _pageState = PageState.LOADING;

  DayTimeSlot _selectDayTImeSlot = DayTimeSlot.empty();
  DayInfo _dayInfo = DayInfo.empty();

  List<DateTime> _days = List.generate(15, (index) => DateTime.now().add(Duration(days: index)));

  @override
  void initState() {
    super.initState();

    appLogs(Screens.AppointmentSelectTimeSlotScreen, tag: screenTag);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _onLoad();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _onLoad() async {
    appLogs("AppointmentSelectTimeSlotScreen:_onLoad");
    _hideLoading();
  }

  _showLoading() {
    appLogs("AppointmentSelectTimeSlotScreen:_showLoading");
    setState(() => _pageState = PageState.LOADING);
  }

  _hideLoading() {
    appLogs("AppointmentSelectTimeSlotScreen:_hideLoading");
    setState(() => _pageState = PageState.LOADED);
  }

  _createAppointment() async {
    if (_selectDayTImeSlot.timeSlot.id.isEmpty) {
      showAlert(
        context: context,
        message: "Please select time slot",
        title: AlertTitle.warning,
      );
      return;
    }

    _showLoading();

    try {
      Appointment appointment = Appointment.empty();
      appointment.date = dateSendFormatter.format(_selectDayTImeSlot.date);
      appointment.timeSlot = _selectDayTImeSlot.timeSlot;
      appointment.counsellorId = widget.counsellor.emailId;
      appointment.studentName =
          auth.currentUser.personalInformation.firstName + " " + auth.currentUser.personalInformation.lastName;

      if (widget.previousAppointment != null) {
        appointment.from = widget.previousAppointment.id;
      }

      DocumentReference documentReference = FirebaseApi(FirestoreCollection.counsellors)
          .ref
          .document(widget.counsellor.emailId)
          .collection(dateSendFormatter.format(_selectDayTImeSlot.date))
          .document(appointment.timeSlot.id);

      DocumentSnapshot snapshot = await documentReference.get();
      if (snapshot.exists) {
        _hideLoading();
        showAlert(
          context: context,
          message: Strings.selectTimeSlot,
          title: AlertTitle.warning,
        );
      } else {
        Map<String, dynamic> data = appointment.toMap();
        appLogs('\n\n appointment.toMap() $data\n\n');
        await documentReference.setData(data);

        if (widget.previousAppointment != null) {
          await FirebaseRepo.rescheduleAppointment(
            rescheduledTo: appointment.id,
            appointment: widget.previousAppointment,
          );
        }

        _hideLoading();
        AppToast.showMessage(Strings.successMessage);

        if (widget.isFirstAppointment) {
          AppRoutes.makeFirst(context, FirstAppointmentStatusScreen(appointment: appointment));
        } else {
          AppRoutes.pop(context);
          AppRoutes.pop(context);
        }
      }
    } catch (e, s) {
      handelException(context, e, s, "_createAppointment");
      _hideLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarCustom(
          title: widget.previousAppointment == null ? Strings.bookAppointment : Strings.rescheduleAppointment,
          style: TextStyles.appBarTittle),
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
    return Form(
      child: Column(
        children: <Widget>[
          Flexible(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: Sizes.s40),
              children: <Widget>[
                CounsellorWidget(
                  counsellor: widget.counsellor,
                  onTap: null,
                ),
                P10(),
                Text(
                  "What Days ?",
                  style: TextStyles.defaultSemiBold,
                  textAlign: TextAlign.left,
                ),
                C10(),
                Container(
                  height: Sizes.screenWidthFifth,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: _days.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return SelectDayReactiveWidget(
                        isSelected: _selectDayTImeSlot.date == _days[index],
                        dateTime: _days[index],
                        onSelect: (DayInfo dayInfo) {
                          setState(() {
                            _selectDayTImeSlot.date = dayInfo.day;
                            _dayInfo = dayInfo;
                          });
                        },
                        emailId: widget.counsellor.emailId,
                        tier: widget.counsellor.tier,
                      );
                    },
                  ),
                ),
                P10(),
                if (_dayInfo.isAvailable)
                  Text(
                    Strings.whatTime,
                    style: TextStyles.defaultSemiBold,
                    textAlign: TextAlign.left,
                  ),
                C10(),
                if (_dayInfo.isAvailable)
                  Container(
                    height: Sizes.screenWidthSixth,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: _dayInfo.availabilityTimeSlots.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return SelectTimeSlotWidget(
                          isSelected: _selectDayTImeSlot.timeSlot == _dayInfo.availabilityTimeSlots[index],
                          timeSlot: _dayInfo.availabilityTimeSlots[index],
                          onSelect: (TimeSlot timeSlot) {
                            setState(() {
                              _selectDayTImeSlot.timeSlot = timeSlot;
                            });
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          AppButton(
            onTap: _createAppointment,
            title: Strings.scheduleAppointment,
          ),
          C10(),
        ],
      ),
    );
  }
}
