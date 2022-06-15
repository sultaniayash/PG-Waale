import 'package:flutter/material.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';

class EmptyWidget extends StatelessWidget {
  final String message;

  const EmptyWidget({Key key, @required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Sizes.s20),
      child: Column(
        children: <Widget>[
          Image(image: AssetImage(Assets.NoResults)),
          C5(),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  message,
                  style: TextStyles.defaultRegular.copyWith(
                    color: Colors.black38,
                    fontSize: FontSize.s20,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
