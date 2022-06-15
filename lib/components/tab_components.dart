import 'package:flutter/material.dart';
import 'package:qbix/theme/app_colors.dart';
import 'package:qbix/theme/textstyles.dart';
import 'package:qbix/utils/a_utils.dart';

class TabHeaderWidget extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final Function(int) onTabChanged;

  const TabHeaderWidget({
    Key key,
    this.tabs,
    this.selectedIndex,
    this.onTabChanged,
  }) : super(key: key);

  double getAlignmentX() {
    if (tabs.length == 2) {
      return selectedIndex == 0 ? -1 : 1;
    } else {
      if (selectedIndex == 0)
        return -1;
      else if (selectedIndex == 1)
        return 0;
      else
        return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Sizes.s6),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int index = 0; index < tabs.length; index++)
                TabHeadWidget(
                  title: tabs[index],
                  isSelected: index == selectedIndex,
                  onTap: () => onTabChanged(index),
                ),
            ],
          ),
          C10(),
          AnimatedContainer(
            duration: Duration(
              milliseconds: Constants.delaySmall,
            ),
            alignment: Alignment(getAlignmentX(), 1),
            width: screenWidth,
            height: Sizes.s6,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: Sizes.s25),
              width: screenWidth / tabs.length * 0.8,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: new BorderRadius.circular(Sizes.s15),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TabHeadWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Function onTap;

  const TabHeadWidget({Key key, this.title, this.isSelected, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkResponse(
        onTap: onTap,
        child: Container(
          child: Text(
            title,
            style: TextStyles.defaultBold.copyWith(
              color: isSelected ? Colors.black : Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
