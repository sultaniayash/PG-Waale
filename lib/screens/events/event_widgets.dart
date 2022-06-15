import 'package:flutter/material.dart';
import 'package:qbix/models/event_model.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';
import 'package:qbix/widgets/label_value_widget.dart';

class EventWidget extends StatelessWidget {
  final Event event;
  final Function onTap;

  const EventWidget({
    Key key,
    @required this.event,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: Sizes.s10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(Sizes.s10)),
          border: Border.all(
            color: AppColors.pinkishGrey,
            width: Sizes.s1,
          ),
          boxShadow: [
            BoxShadow(
              spreadRadius: -Sizes.s6,
              blurRadius: Sizes.s15,
              color: AppColors.pinkishGrey,
              offset: Offset(Sizes.s2, Sizes.s2),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: Sizes.s200,
                  padding: EdgeInsets.all(Sizes.s10),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Assets.HomeBackground),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Sizes.s8),
                      topRight: Radius.circular(Sizes.s8),
                    ),
                  ),
                ),
                Container(
                  height: Sizes.s200,
                  padding: EdgeInsets.all(Sizes.s10),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Sizes.s8),
                      topRight: Radius.circular(Sizes.s8),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      event.eventName,
                      style: TextStyles.defaultBold.copyWith(
                        color: Colors.white,
                        fontSize: FontSize.s30,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                ),
              ],
            ),
            C5(),
            LabelValueWidget(
              label: Strings.time,
              value: event.startTime + " - " + event.endTime,
            ),
            LabelValueWidget(
              label: Strings.date,
              value: formatDateFromDateTime(
                  formatter: dateDOBFormatter, value: event.date),
            ),
            LabelValueWidget(
              label: Strings.place,
              value: '${event.place}',
            ),
          ],
        ),
      ),
    );
  }
}
