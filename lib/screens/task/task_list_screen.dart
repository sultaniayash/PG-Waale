import 'package:after_layout/after_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:firestore_ui/firestore_ui.dart';
import 'package:flutter/material.dart';
import 'package:qbix/components/app_components.dart';
import 'package:qbix/components/custom_appbar_component.dart';
import 'package:qbix/models/task_model.dart';
import 'package:qbix/screens/task/task_detail_screen.dart';
import 'package:qbix/screens/task/task_widgets.dart';
import 'package:qbix/services/a_services.dart';
import 'package:qbix/theme/app_colors.dart';
import 'package:qbix/utils/a_utils.dart';
import 'package:qbix/widgets/empty_widget.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> with AfterLayoutMixin<TaskListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageState _pageState = PageState.LOADING;
  String _message = "";

  PageController _pageController = new PageController();
  int _currentPage = 0;

  List<Task> _list = [
    Task.empty(),
    Task.empty(),
  ];

  @override
  void initState() {
    super.initState();
    appLogs(Screens.TaskListScreen, tag: screenTag);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _onLoad();
  }

  _onLoad() async {
    appLogs("TaskListScreen:_onLoad");
    _hideLoading();
  }

  updateCurrentPage(int page) {
    setState(() {
      _currentPage = page;
    });
    appLogs("_currentPage:$_currentPage");
  }

  onTabChanged(int page) {
    _pageController.animateToPage(
      page,
      duration: Duration(
        milliseconds: Constants.delayMedium,
      ),
      curve: Curves.ease,
    );
    appLogs("goto:$_currentPage");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.white,
      appBar: appBarCustom(
        title: Strings.tasks.toUpperCase(),
      ),
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
    return FirestoreAnimatedList(
      padding: EdgeInsets.symmetric(horizontal: Sizes.s30, vertical: Sizes.s10),
      query: FirebaseRepo.getTasksForStudent(
        uid: auth.currentUser.uid,
      ),
      itemBuilder: (BuildContext context, DocumentSnapshot snapshot, Animation animation, int index) {
        Task task = Task.fromMap(snapshot.data);
        return TaskWidget(
          task: task,
          onTap: () {
            AppRoutes.push(
                context,
                TaskDetailScreen(
                  task: task,
                ));
          },
        );
      },
      emptyChild: EmptyWidget(message: Strings.noTasks),
      errorChild: EmptyWidget(message: AlertTitle.error.toUpperCase()),
      onLoaded: (_) => _hideLoading(),
    );
  }

  _showLoading() {
    appLogs("TaskListScreen:_showLoading");
    setState(() => _pageState = PageState.LOADING);
  }

  _hideLoading() {
    appLogs("TaskListScreen:_hideLoading");
    setState(() => _pageState = PageState.LOADED);
  }

  _showError() {
    appLogs("TaskListScreen:_showError");
    setState(() => _pageState = PageState.ERROR);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
