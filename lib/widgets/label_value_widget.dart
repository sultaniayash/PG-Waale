import 'package:flutter/material.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';

class LabelValueWidget extends StatelessWidget {
  final String label;
  final String value;

  const LabelValueWidget({
    Key key,
    @required this.label,
    @required this.value,
  })  : assert(label != null, "label can't be null"),
        assert(value != null, "value can't be null"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Sizes.s10, vertical: Sizes.s5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: TextStyles.labelStyle,
              textAlign: TextAlign.center,
            ),
          ),
          P10(),
          Expanded(
            child: Text(
              value,
              style: TextStyles.valueText,
              textAlign: TextAlign.start,
            ),
          )
        ],
      ),
    );
  }
}
