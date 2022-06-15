import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qbix/theme/app_colors.dart';
import 'package:qbix/theme/assets.dart';
import 'package:qbix/utils/sizes.dart';

class AppProfileAvatar extends StatelessWidget {
  final String imageURL;
  final String baseURL;
  final double radius;

  const AppProfileAvatar({
    Key key,
    @required this.imageURL,
    this.baseURL,
    this.radius,
  }) : super(key: key);

  /// return true if imageURL is ending with .svg
  bool isSVG() {
    return imageURL.split('.').last.toLowerCase() == 'svg';
  }

  Widget getPlaceHolderAvatar() {
    ///If Image URL is empty or NULL
    ///show Asset placeholder
    return CircleAvatar(
      backgroundColor: AppColors.primary,
      radius: radius ?? Sizes.s30,
      child: ClipOval(
        child: Image.asset(Assets.Account),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ///If Image URL is empty or NULL
    if (imageURL == null || imageURL.isEmpty) {
      return getPlaceHolderAvatar();
    }

    ///if SVG show PlaceHolderAvatar
    if (isSVG()) return getPlaceHolderAvatar();

    String url = imageURL;
    if (baseURL != null && baseURL.isNotEmpty) url = baseURL + imageURL;

    return CircleAvatar(
      backgroundColor: AppColors.pinkishGrey,
      radius: radius ?? Sizes.s30,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: url,
          placeholder: (context, url) => getPlaceHolderAvatar(),
        ),
      ),
    );
  }
}
