import 'package:flutter/material.dart';
import 'package:qbix/components/custom_appbar_component.dart';
import 'package:qbix/models/task_model.dart';
import 'package:qbix/screens/task/task_detail_widget.dart';
import 'package:qbix/theme/app_colors.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({Key key, @required this.task}) : super(key: key);

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageState _pageState = PageState.LOADED;
  String _message = "";

  @override
  void initState() {
    super.initState();
    appLogs(Screens.TutorialScreen, tag: screenTag);
    Future.delayed(Duration(milliseconds: Constants.delaySmall), () => _onLoad());
  }

  _onLoad() async {
    appLogs("TutorialScreen:_onLoad");
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
    return Padding(
      padding: EdgeInsets.all(Sizes.s40),
      child: ListView(
        children: <Widget>[
          Text(
            widget.task.title,
            style: TextStyles.screenHeader,
          ),
          C10(),
          Text(
            widget.task.description,
            style: TextStyles.TaskListScreenSubHeading,
          ),
          C20(),
          Text(
            Strings.completeSubTask,
            style: TextStyles.screenSubHeader,
          ),
          C15(),
          ...widget.task.subTaskList.map((subTask) {
            return SubTaskWidget(
              subTask: subTask,
            );
          }).toList()
        ],
      ),
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
