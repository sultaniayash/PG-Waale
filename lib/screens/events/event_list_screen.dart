import 'package:after_layout/after_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:flutter/material.dart';
import 'package:qbix/components/custom_appbar_component.dart';
import 'package:qbix/components/tab_widgets.dart';
import 'package:qbix/models/event_model.dart';
import 'package:qbix/services/a_services.dart';
import 'package:qbix/theme/app_colors.dart';
import 'package:qbix/utils/a_utils.dart';
import 'package:qbix/widgets/empty_widget.dart';

import 'event_details_screen.dart';
import 'event_widgets.dart';

class EventListScreen extends StatefulWidget {
  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen>
    with AfterLayoutMixin<EventListScreen>, SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageState _pageState = PageState.LOADING;
  String _message = "";

  int _currentIndex = 0;
  int _totalTabs = 2;

  TabController _controller;

  @override
  void initState() {
    super.initState();

    _controller = new TabController(length: _totalTabs, vsync: this)
      ..addListener(() => _updateIndex(_controller.index));
    appLogs(Screens.EventListScreen, tag: screenTag);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    onLoad();
  }

  _updateIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  onLoad() async {
    appLogs("EventListScreen:onLoad");
    _hideLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.white,
      appBar: appBarCustom(
        title: Strings.events,
      ),
      body: Stack(
        children: <Widget>[
          getBody(),
          ScreenLoader(pageState: _pageState),
          AppErrorWidget(
            message: _message,
            pageState: _pageState,
            onTap: onLoad,
          )
        ],
      ),
    );
  }

  Widget getBody() {
    return DefaultTabController(
      length: _totalTabs,
      child: Column(
        children: <Widget>[
          TabBar(
            controller: _controller,
            tabs: <Widget>[
              TabWidget(
                title: Strings.upcoming,
                isActive: _currentIndex == 0,
              ),
              TabWidget(
                title: Strings.registered,
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
                    padding: EdgeInsets.symmetric(
                        horizontal: Sizes.s30, vertical: Sizes.s10),
                    query: FirebaseRepo.getEvents(),
                    itemBuilder: (BuildContext context,
                        DocumentSnapshot snapshot,
                        Animation animation,
                        int index) {
                      Event event = Event.fromMap(snapshot.data);
                      return EventWidget(
                        event: event,
                        onTap: () {
                          AppRoutes.push(
                              context, EventDetailScreen(event: event));
                        },
                      );
                    },
                    emptyChild: EmptyWidget(message: Strings.noEvents),
                    errorChild:
                        EmptyWidget(message: AlertTitle.error.toUpperCase()),
                  ),
                ),
                Offstage(
                  offstage: _currentIndex != 1,
                  child: FirestoreAnimatedList(
                    padding: EdgeInsets.symmetric(
                        horizontal: Sizes.s30, vertical: Sizes.s10),
                    query: FirebaseRepo.getStudentEvents(),
                    itemBuilder: (BuildContext context,
                        DocumentSnapshot snapshot,
                        Animation animation,
                        int index) {
                      Event event = Event.fromMap(snapshot.data);

                      return EventWidget(
                        event: event,
                        onTap: () {
                          AppRoutes.push(
                              context,
                              EventDetailScreen(
                                event: event,
                                isUserEvent: true,
                              ));
                        },
                      );
                    },
                    emptyChild: EmptyWidget(message: Strings.noEvents),
                    errorChild:
                        EmptyWidget(message: AlertTitle.error.toUpperCase()),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _showLoading() {
    appLogs("EventListScreen:_showLoading");
    setState(() => _pageState = PageState.LOADING);
  }

  _hideLoading() {
    appLogs("EventListScreen:_hideLoading");
    setState(() => _pageState = PageState.LOADED);
  }

  _showError() {
    appLogs("EventListScreen:_showError");
    setState(() => _pageState = PageState.ERROR);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
