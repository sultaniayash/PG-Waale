import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qbix/utils/a_utils.dart';

class ScreenLoader extends StatelessWidget {
  final PageState pageState;

  const ScreenLoader({
    Key key,
    @required this.pageState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: pageState != PageState.LOADING,
      child: new Container(
        color: Colors.black38,
        child: new Align(
          alignment: Alignment.center,
          child: Padding(
            padding: Sizes.spacingAllDefault,
            child: new CupertinoActivityIndicator(),
          ),
        ),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator();
  }
}

class FullScreenLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black38,
      child: new Align(
        alignment: Alignment.center,
        child: Padding(
          padding: Sizes.spacingAllDefault,
          child: new CupertinoActivityIndicator(),
        ),
      ),
    );
  }
}
