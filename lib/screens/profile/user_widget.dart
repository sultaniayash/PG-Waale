import 'package:flutter/material.dart';
import 'package:qbix/models/user_model.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';
import 'package:qbix/widgets/image_widget.dart';
import 'package:recase/recase.dart';

class StudentHeadWidget extends StatelessWidget {
  final User user;
  final bool showImage;

  const StudentHeadWidget({
    Key key,
    @required this.user,
    this.showImage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(Sizes.s8),
          padding: EdgeInsets.all(Sizes.s20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                spreadRadius: -Sizes.s6,
                blurRadius: Sizes.s15,
                color: AppColors.pinkishGrey,
                offset: Offset(Sizes.s2, Sizes.s2),
              )
            ],
          ),
          child: Row(
            children: <Widget>[
              if (showImage)
                PersonCircularImage(
                  imageURL: user.personalInformation.firstName,
                  fullName: user.personalInformation.firstName,
                  radius: Sizes.s50,
                ),
              C10(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${user.personalInformation.firstName + " " + user.personalInformation.lastName}'.toUpperCase(),
                      style: TextStyles.defaultBold,
                    ),
                    P5(),
                    Text(
                      user.mobileNumber,
                    ),
                    P5(),
                    Text(
                      user.emailId,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: Sizes.s12,
          right: Sizes.s12,
          child: StudentStatusWidget(
            status: user.leadStatus,
          ),
        ),
      ],
    );
  }
}

class StudentStatusWidget extends StatelessWidget {
  final String status;

  const StudentStatusWidget({Key key, @required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (status.isEmpty) return C0();
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: Sizes.s10, vertical: Sizes.s5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(Sizes.s8)),
              border: Border.all(
                color: Colors.orange,
                width: Sizes.s2,
              ),
            ),
            child: Text(
              (ReCase(status).titleCase).toUpperCase(),
              style: TextStyles.defaultBold.copyWith(
                color: Colors.orange,
                fontSize: FontSize.s10,
              ),
            ),
          )
        ],
      ),
    );
  }
}
