import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qbix/models/task_model.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';

class SubTaskWidget extends StatelessWidget {
  final SubTask subTask;

  const SubTaskWidget({Key key, @required this.subTask}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Sizes.s90,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(color: Color(0xff979797), width: Sizes.s1),
        borderRadius: BorderRadius.circular(Sizes.s8),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: Sizes.s12,
            height: Sizes.s90,
            decoration: BoxDecoration(
                color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                borderRadius:
                    BorderRadius.only(topLeft: Radius.circular(Sizes.s8), bottomLeft: Radius.circular(Sizes.s8))),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: Sizes.s15),
              child: Wrap(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        subTask.title,
                        style: TextStyles.defaultBold,
                      ),
                      C10(),
                      Text(
                        subTask.description,
                        style: TextStyles.cardSubHeading,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
