import 'package:flutter/material.dart';
import 'package:qbix/utils/app_routes.dart';

import 'image_widget.dart';

class FullScreenImageWidget extends StatelessWidget {
  final String imageURL;
  final String tag;

  const FullScreenImageWidget({Key key, @required this.imageURL, @required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Hero(
          tag: tag,
          child: Stack(
            children: <Widget>[
              Center(
                child: AppFullImageWidget(
                  imageURL: imageURL,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Material(
                  color: Colors.black45,
                  child: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      AppRoutes.pop(context);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
