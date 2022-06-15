import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/firestore_ui.dart';
import 'package:flutter/material.dart';
import 'package:qbix/components/alert_component.dart';
import 'package:qbix/components/app_components.dart';
import 'package:qbix/components/tab_widgets.dart';
import 'package:qbix/models/appointment_models.dart';
import 'package:qbix/screens/appointment/select_counsellor_screen.dart';
import 'package:qbix/services/a_services.dart';
import 'package:qbix/theme/app_colors.dart';
import 'package:qbix/utils/a_utils.dart';
import 'package:qbix/widgets/empty_widget.dart';

import 'appointment_select_counsellor_screen.dart';
import 'appointment_widget.dart';

class ViewAppointmentScreen extends StatefulWidget {
  @override
  _ViewAppointmentScreenState createState() => _ViewAppointmentScreenState();
}

class _ViewAppointmentScreenState extends State<ViewAppointmentScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int _totalTabs = 2;

  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: _totalTabs, vsync: this)
      ..addListener(() => _updateIndex(_controller.index));
    appLogs(Screens.ViewAppointmentScreen, tag: screenTag);
  }

  _updateIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _totalTabs,
      child: Scaffold(
        appBar: appBarCustom(title: "APPOINTMENTS"),
        body: Column(
          children: <Widget>[
            TabBar(
              controller: _controller,
              tabs: <Widget>[
                TabWidget(
                  title: "Upcoming",
                  isActive: _currentIndex == 0,
                ),
                TabWidget(
                  title: "Past",
                  isActive: _currentIndex == 1,
                ),
              ],
              indicatorWeight: Sizes.s5,
              indicatorColor: AppColors.pinkishGrey,
              labelPadding: EdgeInsets.zero,
            ),
            Flexible(
              child: Stack(
                children: <Widget>[
                  Offstage(
                    offstage: _currentIndex != 0,
                    child: FirestoreAnimatedList(
                      padding: EdgeInsets.symmetric(horizontal: Sizes.s30, vertical: Sizes.s10),
                      query: FirebaseRepo.getConfirmedAppointmentsForStudent(
                        uid: auth.currentUser.uid,
                      ),
                      itemBuilder: (BuildContext context, DocumentSnapshot snapshot, Animation animation, int index) {
                        Appointment appointment = Appointment.fromMap(snapshot.data);
                        return AppointmentWidget(
                          appointment: appointment,
                          onReschedule: () async {
                            showAlertWithTwoOption(
                              context: context,
                              message: Strings.rescheduleAppointmentConfirmation,
                              title: AlertTitle.alert,
                              positiveButtonText: Strings.YesButtonText,
                              positiveButtonOnTap: () async {
                                if (appointment.status == AppointmentStatus.CONFIRMED) {
                                  AppRoutes.push(
                                      context,
                                      AppointmentSelectCounsellorScreen(
                                        previousAppointment: appointment,
                                        isFirstAppointment: false,
                                      ));
                                }
                              },
                              negativeButtonText: Strings.NoButtonText,
                              negativeButtonOnTap: () {},
                            );
                          },
                          onCancel: () async {
                            showAlertWithTwoOption(
                              context: context,
                              message: Strings.confirmingCancelAppointment,
                              title: AlertTitle.alert,
                              positiveButtonText: Strings.YesButtonText,
                              positiveButtonOnTap: () async {
                                if (appointment.status == AppointmentStatus.CONFIRMED) {
                                  AppRoutes.showLoader(context);
                                  await FirebaseRepo.cancelAppointment(
                                    appointment: appointment,
                                  );
                                  AppRoutes.pop(context);
                                }
                              },
                              negativeButtonText: Strings.NoButtonText,
                              negativeButtonOnTap: () {},
                            );
                          },
                        );
                      },
                      emptyChild: EmptyWidget(message: Strings.noAppointment),
                      errorChild: EmptyWidget(message: AlertTitle.error.toUpperCase()),
                    ),
                  ),
                  Offstage(
                    offstage: _currentIndex != 1,
                    child: FirestoreAnimatedList(
                      padding: EdgeInsets.symmetric(horizontal: Sizes.s30, vertical: Sizes.s10),
                      query: FirebaseRepo.getAppointmentsForStudent(
                        uid: auth.currentUser.uid,
                      ),
                      itemBuilder: (BuildContext context, DocumentSnapshot snapshot, Animation animation, int index) {
                        Appointment appointment = Appointment.fromMap(snapshot.data);
                        if (appointment.status == AppointmentStatus.CONFIRMED) return C0();
                        return AppointmentWidget(
                          appointment: appointment,
                          onReschedule: () async {
                            showAlertWithTwoOption(
                              context: context,
                              message: Strings.rescheduleAppointmentConfirmation,
                              title: AlertTitle.alert,
                              positiveButtonText: Strings.YesButtonText,
                              positiveButtonOnTap: () async {
                                if (appointment.status == AppointmentStatus.CONFIRMED) {
                                  AppRoutes.push(
                                      context,
                                      AppointmentSelectCounsellorScreen(
                                        previousAppointment: appointment,
                                        isFirstAppointment: false,
                                      ));
                                }
                              },
                              negativeButtonText: Strings.NoButtonText,
                              negativeButtonOnTap: () {},
                            );
                          },
                          onCancel: () async {
                            showAlertWithTwoOption(
                              context: context,
                              message: Strings.confirmingCancelAppointment,
                              title: AlertTitle.alert,
                              positiveButtonText: Strings.YesButtonText,
                              positiveButtonOnTap: () async {
                                if (appointment.status == AppointmentStatus.CONFIRMED) {
                                  AppRoutes.showLoader(context);
                                  await FirebaseRepo.cancelAppointment(
                                    appointment: appointment,
                                  );
                                  AppRoutes.pop(context);
                                }
                              },
                              negativeButtonText: Strings.NoButtonText,
                              negativeButtonOnTap: () {},
                            );
                          },
                        );
                      },
                      emptyChild: EmptyWidget(message: Strings.noAppointment),
                      errorChild: EmptyWidget(
                        message: AlertTitle.error.toUpperCase(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: Sizes.s30,
          ),
          backgroundColor: AppColors.primary,
          onPressed: () {
            AppRoutes.push(context, SelectCounsellorScreen());
          },
        ),
      ),
    );
  }
}
