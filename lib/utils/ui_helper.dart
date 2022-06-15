import 'package:flutter/material.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';

class P1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(Sizes.s1));
  }
}

class P2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(Sizes.s2));
  }
}

class P5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(Sizes.s5));
  }
}

class P8 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(Sizes.s8));
  }
}

class P10 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(Sizes.s10));
  }
}

class PH10 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: Sizes.s10));
  }
}

class P20 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(Sizes.s20));
  }
}

class P30 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(Sizes.s30));
  }
}

class P40 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(Sizes.s40));
  }
}

class C0 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }
}

class C1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Sizes.s1,
      width: Sizes.s1,
    );
  }
}

class C2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Sizes.s2,
      width: Sizes.s2,
    );
  }
}

class C5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Sizes.s5,
      width: Sizes.s5,
    );
  }
}

class C10 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Sizes.s10,
      width: Sizes.s10,
    );
  }
}

class C15 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Sizes.s15,
      width: Sizes.s15,
    );
  }
}

class C20 extends StatelessWidget {
  final Color color;

  const C20({Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? Colors.transparent,
      height: Sizes.s20,
      width: Sizes.s20,
    );
  }
}

class C25 extends StatelessWidget {
  final Color color;

  const C25({Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? Colors.transparent,
      height: Sizes.s25,
      width: Sizes.s25,
    );
  }
}

class C30 extends StatelessWidget {
  final Color color;

  const C30({Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? Colors.transparent,
      height: Sizes.s30,
      width: Sizes.s30,
    );
  }
}

class C50 extends StatelessWidget {
  final Color color;

  const C50({Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? Colors.transparent,
      height: Sizes.s50,
      width: Sizes.s50,
    );
  }
}

class DashedLineWidget extends StatelessWidget {
  final int dashNumber;

  const DashedLineWidget({Key key, this.dashNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(dashNumber ?? Constants.dashNumber, (index) {}).map((value) {
          return Container(
            height: Sizes.s2,
            width: Sizes.s5,
            color: AppColors.primary,
          );
        }).toList(),
      ),
    );
  }
}

class LineWidgetVertical extends StatelessWidget {
  const LineWidgetVertical({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Flexible(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: Sizes.s8),
                  width: Sizes.s2,
                  color: AppColors.primary,
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: RotatedBox(
              quarterTurns: -45,
              child: Icon(
                Icons.play_arrow,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
