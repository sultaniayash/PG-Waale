import 'package:flutter/material.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';

class TabWidget extends StatelessWidget {
  final String title;
  final bool isActive;

  const TabWidget({
    Key key,
    @required this.title,
    @required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.all(Sizes.s4),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: isActive
                  ? TextStyles.defaultSemiBold.copyWith(
                      color: Colors.white,
                      fontSize: FontSize.s15,
                    )
                  : TextStyles.defaultRegular.copyWith(
                      color: Colors.white,
                      fontSize: FontSize.s15,
                    ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
