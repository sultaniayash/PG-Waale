import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qbix/components/app_components.dart';
import 'package:qbix/models/event_model.dart';
import 'package:qbix/models/master_data_model.dart';
import 'package:qbix/screens/qrcode/qrcode_screen.dart';
import 'package:qbix/services/a_services.dart';
import 'package:qbix/services/auth_service.dart';
import 'package:qbix/theme/app_colors.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';
import 'package:qbix/widgets/label_value_widget.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;
  final bool isUserEvent;

  const EventDetailScreen({
    Key key,
    @required this.event,
    this.isUserEvent = false,
  }) : super(key: key);

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageState _pageState = PageState.LOADING;
  String _message = "";

  @override
  void initState() {
    super.initState();
    appLogs(Screens.EventDetailScreen, tag: screenTag);
    Future.delayed(
        Duration(milliseconds: Constants.delaySmall), () => _onLoad());
  }

  _onLoad() async {
    appLogs("TutorialScreen:_onLoad");
    _hideLoading();
  }

  _registerEvent() async {
    try {
      _showLoading();

      //Check for event type max registration
      EventType eventType = MasterData.get().eventTypeList.firstWhere(
            (data) => data.eventName == widget.event.eventType,
          );

      int totalEventRegistration =
          (await FirebaseApi(FirestoreCollection.students)
                  .getDocumentRef(auth.currentUser.uid)
                  .collection(FirestoreCollection.studentEvents)
                  .where(APIKeys.eventType, isEqualTo: widget.event.eventType)
                  .getDocuments())
              .documents
              .length;

      if (totalEventRegistration < eventType.maxEnrollCount) {
        //Check if already registered for
        DocumentReference eventDocumentReference =
            FirebaseApi(FirestoreCollection.events)
                .getDocumentRef(widget.event.id)
                .collection(FirestoreCollection.students)
                .document(auth.currentUser.uid);

        if ((await eventDocumentReference.get()).exists) {
          _hideLoading();
          showAlert(
            context: context,
            message: Strings.alreadyRegistered,
            title: AlertTitle.warning,
          );
          return;
        }
        EventStudent eventStudent = EventStudent.empty();
        eventStudent.studentId = auth.currentUser.uid;
        eventStudent.name = auth.currentUser.fullName;
        eventStudent.mobileNumber = auth.currentUser.mobileNumber;
        eventStudent.emailId = auth.currentUser.emailId;
        await eventDocumentReference.setData(eventStudent.toMap(), merge: true);
        await FirebaseApi(FirestoreCollection.students)
            .getDocumentRef(eventStudent.studentId)
            .collection(FirestoreCollection.studentEvents)
            .document(widget.event.id)
            .setData(widget.event.toMap(), merge: true);
        _hideLoading();
        showAlert(
          context: context,
          message: Strings.eventRegisteredSuccess,
          title: AlertTitle.success,
        );
      } else {
        _hideLoading();
        showAlert(
          context: context,
          message: Strings.alreadyEventRegistered,
          title: AlertTitle.warning,
        );
      }
    } catch (e, s) {
      handelException(context, e, s, "_registerEvent");
      _hideLoading();
    }
  }

  _markAttendance() async {
    DocumentReference eventDocumentReference =
        FirebaseApi(FirestoreCollection.events)
            .getDocumentRef(widget.event.id)
            .collection(FirestoreCollection.students)
            .document(auth.currentUser.uid);

    DocumentSnapshot snapshot = await eventDocumentReference.get();
    EventStudent eventStudent = EventStudent.fromMap(snapshot.data);
    if (eventStudent.attended) {
      showAlert(
        context: context,
        message: Strings.alreadyMarkedAttedned,
        title: AlertTitle.alert.toUpperCase(),
      );
    } else {
      AppRoutes.push(
          context,
          QWCodeScreen(
            title: Strings.markAttendance,
            subTitle: widget.event.eventName,
            callback: (String data) async {
              appLogs(data);
              if (data == '${Constants.qrCodePrefix + widget.event.id}') {
                await eventDocumentReference.setData({
                  APIKeys.attended: true,
                  APIKeys.updatedAt: dateSendFormatter.format(DateTime.now()),
                }, merge: true);
                await FirebaseApi(FirestoreCollection.students)
                    .getDocumentRef(eventStudent.studentId)
                    .collection(FirestoreCollection.studentEvents)
                    .document(widget.event.id)
                    .setData({
                  APIKeys.attended: true,
                  APIKeys.updatedAt: dateSendFormatter.format(DateTime.now()),
                }, merge: true);
                setState(() {
                  widget.event.attended = true;
                });
                showAlert(
                    context: context,
                    message: Strings.attendanceSuccess,
                    title: AlertTitle.alert.toUpperCase(),
                    positiveButtonOnTap: () {
                      AppRoutes.pop(context);
                    });
              } else {
                showAlert(
                  context: context,
                  message: Strings.invalidQR,
                  title: AlertTitle.error.toUpperCase(),
                );
              }
            },
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.white,
      appBar: appBarCustom(title: Strings.eventDetails),
      body: Stack(
        children: <Widget>[
          getBody(),
          ScreenLoader(pageState: _pageState),
          AppErrorWidget(
            message: _message,
            pageState: _pageState,
            onTap: _onLoad,
          )
        ],
      ),
    );
  }

  Widget getBody() {
    return ListView(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              height: Sizes.s200,
              padding: EdgeInsets.all(Sizes.s10),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.HomeBackground),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Sizes.s8),
                  topRight: Radius.circular(Sizes.s8),
                ),
              ),
            ),
            Container(
              height: Sizes.s200,
              padding: EdgeInsets.all(Sizes.s10),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Sizes.s8),
                  topRight: Radius.circular(Sizes.s8),
                ),
              ),
              child: Center(
                child: Text(
                  widget.event.eventName,
                  style: TextStyles.defaultBold.copyWith(
                    color: Colors.white,
                    fontSize: FontSize.s30,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
            ),
          ],
        ),
        C5(),
        LabelValueWidget(
          label: Strings.time,
          value: widget.event.startTime + " - " + widget.event.endTime,
        ),
        LabelValueWidget(
          label: Strings.date,
          value: formatDateFromDateTime(
              formatter: dateDOBFormatter, value: widget.event.date),
        ),
        LabelValueWidget(
          label: Strings.place,
          value: '${widget.event.place}',
        ),
        Padding(
          padding: EdgeInsets.all(Sizes.s10),
          child: Text(
            widget.event.eventDescription,
            style: TextStyles.defaultRegular,
          ),
        ),
        if (!widget.isUserEvent)
          Padding(
            padding: EdgeInsets.all(Sizes.s10),
            child: Text(
              "${widget.event.seats - widget.event.enrollCount} seats left!",
              style: TextStyles.defaultSemiBold.copyWith(
                color: Colors.green.shade400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        C5(),
        if (!widget.isUserEvent)
          Padding(
            padding: EdgeInsets.all(Sizes.s10),
            child: AppButton(
              title: Strings.registrationTitle.toUpperCase(),
              onTap: _registerEvent,
              padding: EdgeInsets.symmetric(
                horizontal: Sizes.s10,
                vertical: Sizes.s10,
              ),
            ),
          ),
        if (widget.isUserEvent && !widget.event.attended)
          Padding(
            padding: EdgeInsets.all(Sizes.s10),
            child: AppButton(
              title: Strings.markAttendance,
              onTap: _markAttendance,
              padding: EdgeInsets.symmetric(
                horizontal: Sizes.s10,
                vertical: Sizes.s10,
              ),
            ),
          ),
        if (widget.event.attended)
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: Sizes.s30, vertical: Sizes.s10),
            child: Text(
              Strings.attendedEvent,
              style: TextStyles.defaultBold
                  .copyWith(fontSize: FontSize.s20, color: Colors.green),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  _showLoading() {
    appLogs("TutorialScreen:_showLoading");
    setState(() => _pageState = PageState.LOADING);
  }

  _hideLoading() {
    appLogs("TutorialScreen:_hideLoading");
    setState(() => _pageState = PageState.LOADED);
  }

  _showError() {
    appLogs("TutorialScreen:_showError");
    setState(() => _pageState = PageState.ERROR);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
