import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:qbix/models/category_model.dart';
import 'package:qbix/models/documents_model.dart';
import 'package:qbix/models/register_models.dart';
import 'package:qbix/models/sub_category_model.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';
import 'package:qbix/utils/sizes.dart';

class CountryWidget extends StatelessWidget {
  final AppCountry appCountry;
  final Function onTap;

  const CountryWidget({
    Key key,
    @required this.appCountry,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        margin: EdgeInsets.all(Sizes.s15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              CountryPickerUtils.getFlagImageAssetPath(appCountry.isoCode),
              height: Sizes.s100,
              width: screenWidth,
              fit: BoxFit.fill,
              package: "country_pickers",
            ),
            C10(),
            Text(
              appCountry.name.toUpperCase(),
              style: TextStyles.defaultBold,
            )
          ],
        ),
      ),
    );
  }
}

class CategoryDataBankWidget extends StatelessWidget {
  final CategoryDataBank categoryDataBank;
  final Function onTap;

  const CategoryDataBankWidget({
    Key key,
    @required this.categoryDataBank,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(Sizes.s10)),
          boxShadow: [
            BoxShadow(
              spreadRadius: -Sizes.s6,
              blurRadius: Sizes.s15,
              color: AppColors.pinkishGrey,
              offset: Offset(Sizes.s2, Sizes.s2),
            )
          ],
        ),
        padding: EdgeInsets.all(Sizes.s12),
        margin: EdgeInsets.only(bottom: Sizes.s10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    categoryDataBank.name,
                    style: TextStyles.defaultBold,
                  ),
                  if (categoryDataBank.description.isNotEmpty) C5(),
                  if (categoryDataBank.description.isNotEmpty)
                    Text(
                      categoryDataBank.description,
                      style: TextStyles.defaultRegular.copyWith(
                        fontSize: FontSize.s10,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_right,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}

class SubCategoryDataBankWidget extends StatelessWidget {
  final SubCategoryDataBank subCategoryDataBank;
  final Function onTap;

  const SubCategoryDataBankWidget({
    Key key,
    @required this.subCategoryDataBank,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(Sizes.s10)),
          boxShadow: [
            BoxShadow(
              spreadRadius: -Sizes.s6,
              blurRadius: Sizes.s15,
              color: AppColors.pinkishGrey,
              offset: Offset(Sizes.s2, Sizes.s2),
            )
          ],
        ),
        padding: EdgeInsets.all(Sizes.s12),
        margin: EdgeInsets.only(bottom: Sizes.s10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    subCategoryDataBank.name,
                    style: TextStyles.defaultBold,
                  ),
                  if (subCategoryDataBank.description.isNotEmpty) C5(),
                  if (subCategoryDataBank.description.isNotEmpty)
                    Text(
                      subCategoryDataBank.description,
                      style: TextStyles.defaultRegular.copyWith(
                        fontSize: FontSize.s10,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_right,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  final String title;

  const TopBar({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'TopBar',
      child: Container(
        padding: EdgeInsets.all(Sizes.s5),
        color: AppColors.primary,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                title.toUpperCase(),
                style: TextStyles.defaultRegular.copyWith(
                  color: Colors.white,
                  fontSize: FontSize.s12,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DocumentWidget extends StatelessWidget {
  final AppDocument appDocument;
  final Function onTap;
  final double size;

  const DocumentWidget({
    Key key,
    @required this.appDocument,
    @required this.onTap,
    this.size,
  }) : super(key: key);

  IconData getIconData() {
    switch (appDocument.type) {
      case AppFileType.TEXT:
        return Icons.text_fields;
        break;
      case AppFileType.IMAGE:
        return Icons.image;
        break;
      case AppFileType.VIDEO:
        return Icons.ondemand_video;
        break;
      case AppFileType.PDF:
        return Icons.picture_as_pdf;
        break;
      case AppFileType.FILE:
      default:
        return Icons.insert_drive_file;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(Sizes.s10)),
          boxShadow: [
            BoxShadow(
              spreadRadius: -Sizes.s6,
              blurRadius: Sizes.s15,
              color: AppColors.pinkishGrey,
              offset: Offset(Sizes.s2, Sizes.s2),
            )
          ],
        ),
        padding: EdgeInsets.all(Sizes.s8),
        margin: EdgeInsets.all(Sizes.s8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Icon(
              getIconData(),
              size: size ?? Sizes.s100,
              color: AppColors.primary,
            ),
            Text(
              appDocument.name,
              style: TextStyles.defaultBold,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );

    return Container();
  }
}
