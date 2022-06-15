import 'package:flutter/material.dart';
import 'package:qbix/components/buttons_component.dart';
import 'package:qbix/models/appointment_models.dart';
import 'package:qbix/models/time_slot_model.dart';
import 'package:qbix/reactive_components/base_reactive_wiget.dart';
import 'package:qbix/services/a_services.dart';
import 'package:qbix/theme/app_colors.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';
import 'package:qbix/utils/sizes.dart';

class SelectDayReactiveWidget extends StatelessWidget {
  final String emailId;
  final DateTime dateTime;
  final bool isSelected;
  final int tier;
  final Function(DayInfo) onSelect;

  const SelectDayReactiveWidget({
    Key key,
    @required this.emailId,
    @required this.dateTime,
    @required this.tier,
    @required this.isSelected,
    @required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactiveWidget<Map>(
      reactiveRef:
          FirebaseRepo.getDayInfo(day: dateTime, counsellorEmailId: emailId),
      widgetBuilder: (data) {
        DayInfo dayInfo = DayInfo.empty();
        if (data.isEmpty) {
          dayInfo = DayInfo.fromMasterData(day: dateTime, tier: tier);
        } else {
          dayInfo = DayInfo.fromMap(day: dateTime, data: data, tier: tier);
        }
        return SelectDayWidget(
          isSelected: isSelected,
          onSelect: onSelect,
          dayInfo: dayInfo,
        );
      },
      fallbackValue: {},
    );
  }
}

class SelectDayWidget extends StatelessWidget {
  final bool isSelected;
  final DayInfo dayInfo;
  final Function(DayInfo) onSelect;

  const SelectDayWidget({
    Key key,
    @required this.onSelect,
    @required this.isSelected,
    @required this.dayInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () {
        if (dayInfo.isAvailable) {
          onSelect(dayInfo);
        } else {
          AppToast.showMessage(AlertTitle.notAvailable);
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: Constants.delayMedium),
        margin: EdgeInsets.all(Sizes.s10),
        width: Sizes.s100,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : dayInfo.isAvailable ? Colors.grey.shade300 : Colors.grey,
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primary
                  : dayInfo.isAvailable ? Colors.grey.shade300 : Colors.grey,
              spreadRadius: 1,
              blurRadius: 1,
            ),
          ],
          borderRadius: new BorderRadius.circular(Sizes.s15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              dayOfMonthFormatter.format(dayInfo.day),
              style: TextStyles.defaultBold.copyWith(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: FontSize.s13,
              ),
            ),
            C5(),
            Text(
              dayMonthFormatter.format(dayInfo.day),
              style: TextStyles.defaultBold.copyWith(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            C5(),
            if (!dayInfo.isAvailable)
              Text(
                AlertTitle.notAvailable,
                style: TextStyles.defaultBold.copyWith(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: FontSize.s8,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SelectTimeSlotWidget extends StatelessWidget {
  final TimeSlot timeSlot;
  final bool isSelected;
  final Function(TimeSlot) onSelect;

  const SelectTimeSlotWidget({
    Key key,
    @required this.timeSlot,
    @required this.onSelect,
    @required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () {
        if (timeSlot.isAvailable) {
          onSelect(timeSlot);
        } else {
          AppToast.showMessage(AlertTitle.notAvailable);
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: Constants.delayMedium),
        margin: EdgeInsets.all(Sizes.s10),
        width: Sizes.s100,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : timeSlot.isAvailable ? Colors.grey.shade300 : Colors.grey,
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primary
                  : timeSlot.isAvailable ? Colors.grey.shade300 : Colors.grey,
              spreadRadius: 1,
              blurRadius: 1,
            ),
          ],
          borderRadius: new BorderRadius.circular(Sizes.s15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              timeSlot.startTime + " - " + timeSlot.endTime,
              style: TextStyles.defaultBold.copyWith(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: FontSize.s13,
              ),
            ),
            C5(),
            if (!timeSlot.isAvailable)
              Text(
                AlertTitle.notAvailable,
                style: TextStyles.defaultBold.copyWith(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: FontSize.s8,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AppointmentStatusWidget extends StatelessWidget {
  final String status;

  const AppointmentStatusWidget({Key key, @required this.status})
      : super(key: key);

  Color getColor() {
    if (status == AppointmentStatus.CONFIRMED) return Colors.green;
    if (status == AppointmentStatus.CANCELLED) return Colors.red;
    if (status == AppointmentStatus.IN_PROGRESS) return Colors.yellow;
    if (status == AppointmentStatus.FINISHED) return Colors.grey;

    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: Sizes.s10, vertical: Sizes.s5),
            decoration: BoxDecoration(
              color: getColor().withOpacity(0.8),
              borderRadius: BorderRadius.all(Radius.circular(Sizes.s8)),
              border: Border.all(
                color: getColor(),
                width: Sizes.s2,
              ),
            ),
            child: Text(
              status.toUpperCase(),
              style: TextStyles.defaultBold.copyWith(
                color: Colors.white,
                fontSize: FontSize.s10,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AppointmentWidget extends StatelessWidget {
  final Appointment appointment;
  final Function onReschedule;
  final Function onCancel;

  const AppointmentWidget({
    Key key,
    @required this.appointment,
    @required this.onReschedule,
    @required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Sizes.s10),
      margin: EdgeInsets.symmetric(vertical: Sizes.s10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(Sizes.s10)),
        border: Border.all(
          color: AppColors.pinkishGrey,
          width: Sizes.s1,
        ),
        boxShadow: [
          BoxShadow(
            spreadRadius: -Sizes.s6,
            blurRadius: Sizes.s15,
            color: AppColors.pinkishGrey,
            offset: Offset(Sizes.s2, Sizes.s2),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  appointment.timeSlot.startTime +
                      " - " +
                      appointment.timeSlot.endTime,
                  style: TextStyles.defaultBold.copyWith(
                    color: AppColors.primary,
                    fontSize: FontSize.s18,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              AppointmentStatusWidget(
                status: appointment.status,
              )
            ],
          ),
          C5(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.yellow,
                radius: Sizes.s15,
                child: Image(
                  image: AssetImage(
                    Assets.Calendar,
                  ),
                  height: Sizes.s18,
                  width: Sizes.s18,
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: Sizes.s5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Appointment with ${appointment.counsellorId.split("@").first}",
                        style: TextStyles.defaultBold.copyWith(
                          fontSize: FontSize.s15,
                        ),
                      ),
                      C5(),
                      Text(
                        appointment.reason,
                        style: TextStyles.defaultRegular.copyWith(
                          fontSize: FontSize.s10,
                        ),
                      ),
                      C10(),
                      if (appointment.status == AppointmentStatus.CONFIRMED)
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: AppOutLineButton(
                                text: Strings.reschedule,
                                onTap: onReschedule,
                                color: Colors.orange,
                                padding: EdgeInsets.symmetric(
                                  horizontal: Sizes.s10,
                                  vertical: Sizes.s5,
                                ),
                              ),
                            ),
                            C5(),
                            Expanded(
                              child: AppOutLineButton(
                                text: Strings.negativeButtonText.toUpperCase(),
                                onTap: onCancel,
                                color: Colors.red,
                                padding: EdgeInsets.symmetric(
                                  horizontal: Sizes.s10,
                                  vertical: Sizes.s5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (appointment.status == AppointmentStatus.IN_PROGRESS)
                        Text(
                          Strings.meetingInProgress,
                          style: TextStyles.defaultBold
                              .copyWith(color: Colors.green),
                        ),
                      if (appointment.status == AppointmentStatus.FINISHED)
                        Text(
                          Strings.meetingFinished,
                          style: TextStyles.defaultBold
                              .copyWith(color: Colors.green),
                        )
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
