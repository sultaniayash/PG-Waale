import 'package:flutter/material.dart';
import 'package:qbix/components/app_profile_avator.dart';
import 'package:qbix/models/counsellor_model.dart';
import 'package:qbix/theme/app_colors.dart';
import 'package:qbix/theme/textstyles.dart';
import 'package:qbix/utils/a_utils.dart';
import 'package:qbix/utils/sizes.dart';

class CounsellorWidget extends StatelessWidget {
  final Counsellor counsellor;
  final Function onTap;

  const CounsellorWidget({Key key, @required this.counsellor, @required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: Sizes.s10),
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: Sizes.s50),
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
              child: Container(
                constraints: BoxConstraints(
                  minHeight: Sizes.s100,
                ),
                padding: EdgeInsets.symmetric(horizontal: Sizes.s40, vertical: Sizes.s10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      counsellor.name,
                      style: TextStyles.defaultBold.copyWith(
                        fontSize: FontSize.s21,
                        color: AppColors.primary,
                      ),
                    ),
                    P5(),
                    Text(
                      counsellor.gender.toUpperCase(),
                      style: TextStyles.defaultRegular.copyWith(
                        fontSize: FontSize.s14,
                        color: AppColors.pinkishGrey,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: Sizes.s10,
              child: AppProfileAvatar(
                imageURL: counsellor.imageURL,
                radius: Sizes.s40,
              ),
            )
          ],
        ),
      ),
    );
  }
}
