import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:photo_view/photo_view.dart';
import 'package:qbix/services/api_service.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';
import 'package:qbix/widgets/loader_widget.dart';

class AppImageWidget extends StatelessWidget {
  final double width;
  final double height;
  final String imageURL;

  const AppImageWidget({
    Key key,
    @required this.imageURL,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new CachedNetworkImage(
      imageUrl: imageURL,
      placeholder: (context, url) => ImagePlaceholderWidget(
        width: width,
        height: height,
      ),
      errorWidget: (context, url, error) => ImageErrorWidget(width: width, height: height),
      width: width,
      height: height,
      fit: BoxFit.fill,
    );
  }
}

class AppFullImageWidget extends StatelessWidget {
  final String imageURL;

  const AppFullImageWidget({
    Key key,
    @required this.imageURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhotoView(
      imageProvider: CachedNetworkImageProvider(imageURL),
    );
  }
}

class ImageLayerWidget extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const ImageLayerWidget({Key key, this.width, this.height, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? Colors.black87.withOpacity(0.65),
      width: width ?? Sizes.defaultImageHeight,
      height: height ?? Sizes.defaultImageHeight,
    );
  }
}

class AppCircularImageWidget extends StatefulWidget {
  final double radius;
  final String imageURL;

  const AppCircularImageWidget({
    Key key,
    @required this.imageURL,
    this.radius,
  }) : super(key: key);

  @override
  _AppCircularImageWidgetState createState() => _AppCircularImageWidgetState();
}

class _AppCircularImageWidgetState extends State<AppCircularImageWidget> {
  bool invalidURL = false;

  @override
  Widget build(BuildContext context) {
    if (widget.imageURL == null || widget.imageURL.isEmpty)
      return CircleAvatar(
        radius: widget.radius ?? Sizes.defaultImageRadius,
        backgroundColor: AppColors.primary,
        child: Icon(
          Icons.perm_identity,
          color: AppColors.primary,
          size: (widget.radius ?? Sizes.defaultImageRadius) * 1.3,
        ),
      );

    return invalidURL
        ? CircleAvatar(
            radius: widget.radius ?? Sizes.defaultImageRadius,
            backgroundColor: AppColors.primary,
            child: Icon(
              Icons.perm_identity,
              color: AppColors.primary,
              size: widget.radius ?? Sizes.defaultImageRadius,
            ),
          )
        : Stack(
            children: <Widget>[
              CircleAvatar(
                radius: widget.radius ?? Sizes.defaultImageRadius,
                backgroundColor: AppColors.primary,
                child: Icon(
                  Icons.perm_identity,
                  color: AppColors.primary,
                  size: widget.radius ?? Sizes.defaultImageRadius,
                ),
              ),
              CircleAvatar(
                radius: widget.radius ?? Sizes.defaultImageRadius,
                backgroundImage: CachedNetworkImageProvider(widget.imageURL, errorListener: () {
                  setState(() {
                    invalidURL = true;
                  });
                  appLogs("Invalid Image URL :${widget.imageURL}");
                }),
                backgroundColor: Colors.transparent,
              ),
            ],
          );
  }
}

class ImagePlaceholderWidget extends StatelessWidget {
  final double width;
  final double height;

  const ImagePlaceholderWidget({Key key, @required this.width, @required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Center(
        child: LoadingWidget(),
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.VS),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

class ImageErrorWidget extends StatelessWidget {
  final double width;
  final double height;

  const ImageErrorWidget({Key key, @required this.width, @required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.VS),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

class PersonCircularImage extends StatefulWidget {
  final double radius;
  final String fullName;
  final String imageURL;

  const PersonCircularImage({
    Key key,
    @required this.radius,
    @required this.fullName,
    @required this.imageURL,
  }) : super(key: key);

  @override
  _PersonCircularImageState createState() => _PersonCircularImageState();
}

class _PersonCircularImageState extends State<PersonCircularImage> {
  bool _invalidURL = false;
  String first = "";

  String getFirstCh(String name) {
    if (name != null && name.isNotEmpty)
      return name.substring(0, 1).toUpperCase();
    else
      return "#";
  }

  Widget getTextPlaceHolder() {
    return CircleAvatar(
      radius: widget.radius ?? Sizes.defaultImageRadius,
      backgroundColor: AppColors.primary,
      child: Center(
        child: Text(
          '${getFirstCh(widget.fullName)}',
          style: TextStyles.defaultRegular.copyWith(
            fontSize: widget.radius,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String url = "";
    if ((widget.imageURL != null && widget.imageURL.isNotEmpty)) {
      if (widget.imageURL.contains("http"))
        url = widget.imageURL;
      else
        url = (API.baseURL + widget.imageURL);
    } else {
      url = widget.imageURL ?? "";
    }

    if (url.isEmpty) return getTextPlaceHolder();

    return InkWell(
      onTap: () {
        appLogs('IMAGE URL InvalidURL:$_invalidURL : $url');
      },
      child: Stack(
        children: <Widget>[
          getTextPlaceHolder(),
          if (!_invalidURL)
            CircleAvatar(
              radius: widget.radius ?? Sizes.defaultImageRadius,
              backgroundImage: CachedNetworkImageProvider(url, errorListener: () {
                appLogs("Invalid Image URL :${widget.imageURL}");
              }),
              backgroundColor: Colors.transparent,
            ),
        ],
      ),
    );
  }
}
