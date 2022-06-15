import 'package:flutter/material.dart';
import 'package:qbix/components/buttons_component.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';

class HeadingWidget extends StatelessWidget {
  final String title;
  final String subheading;
  final Function onTap;

  const HeadingWidget({
    Key key,
    @required this.title,
    @required this.subheading,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Sizes.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyles.defaultBold.copyWith(fontSize: FontSize.s14),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                subheading,
                style: TextStyles.hintStyle.copyWith(
                    fontSize: FontSize.s13, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onTap: onTap,
                text: Strings.viewAll,
                textStyle:
                    TextStyles.defaultBold.copyWith(fontSize: FontSize.s12),
                padding: EdgeInsets.all(Sizes.s5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
