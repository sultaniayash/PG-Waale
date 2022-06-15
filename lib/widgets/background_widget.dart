import 'package:flutter/material.dart';
import 'package:qbix/theme/assets.dart';
import 'package:qbix/utils/app_constants.dart';

class BackgroundWidget extends StatelessWidget {
  final String asset;

  const BackgroundWidget({Key key, this.asset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  asset ?? Assets.Background,
                ),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BackgroundOverlayWidget extends StatelessWidget {
  final Color color;

  const BackgroundOverlayWidget({Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(color ?? Constants.splashOpacity),
            ),
          ),
        ),
      ],
    );
  }
}
