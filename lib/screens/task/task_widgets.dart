import 'package:flutter/material.dart';
import 'package:qbix/models/task_model.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';

class TaskWidget extends StatelessWidget {
  final Task task;
  final Function onTap;

  const TaskWidget({
    Key key,
    @required this.task,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      child: Container(
        height: Sizes.s100,
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Sizes.s8),
            border: Border.all(
              color: Colors.grey.shade400,
              width: 0.3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                blurRadius: Sizes.s10,
                spreadRadius: -Sizes.s6,
                offset: Offset(0, 2),
              ),
            ]),
        margin: EdgeInsets.all(Sizes.s6),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.all(Sizes.s10),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Sizes.s8),
                    bottomLeft: Radius.circular(Sizes.s8),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      task.status,
                      style: TextStyles.cardColoredHeader,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      getDateText(task.dueDate).toUpperCase(),
                      style: TextStyles.cardColoredSubHeader,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(Sizes.s10),
                    child: Text(
                      task.title,
                      style: TextStyles.defaultBold,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(Sizes.s10),
                    child: Text(
                      task.description,
                      style: TextStyles.cardSubHeading,
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
