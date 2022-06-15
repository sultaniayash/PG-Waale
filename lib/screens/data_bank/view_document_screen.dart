import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:qbix/components/app_components.dart';
import 'package:qbix/components/custom_appbar_component.dart';
import 'package:qbix/models/documents_model.dart';
import 'package:qbix/services/file_service.dart';
import 'package:qbix/theme/app_colors.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';
import 'package:qbix/widgets/image_widget.dart';
import 'package:video_player/video_player.dart';

class ViewDocumentScreen extends StatefulWidget {
  final AppDocument appDocument;

  const ViewDocumentScreen({Key key, @required this.appDocument}) : super(key: key);

  @override
  _ViewDocumentScreenState createState() => _ViewDocumentScreenState();
}

class _ViewDocumentScreenState extends State<ViewDocumentScreen> with AfterLayoutMixin<ViewDocumentScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageState _pageState = PageState.LOADED;
  String _message = "";

  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    appLogs(Screens.ViewDocumentScreen, tag: screenTag);
    if (widget.appDocument.type == AppFileType.VIDEO) {
      _controller = VideoPlayerController.network(widget.appDocument.url)
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _onLoad();
  }

  _onLoad() async {
    appLogs("ViewDocumentScreen:_onLoad");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.white,
      appBar: appBarCustom(
        title: Strings.viewDocument,
      ),
      body: Stack(
        children: <Widget>[
          getBody(),
          ScreenLoader(pageState: _pageState),
          AppErrorWidget(
            message: _message,
            pageState: _pageState,
            onTap: _onLoad,
          )
        ],
      ),
    );
  }

  Widget getBody() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: Sizes.s40),
          child: AppTextFormField(
            label: Strings.title,
            hintText: Strings.title,
            initialValue: widget.appDocument.name,
            enabled: false,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: Sizes.s40, vertical: Sizes.s5),
          child: Text(widget.appDocument.description),
        ),
        P10(),
        if (widget.appDocument.type == AppFileType.IMAGE)
          Flexible(
            child: AppFullImageWidget(imageURL: widget.appDocument.url),
          ),
        if (widget.appDocument.type == AppFileType.PDF)
          Flexible(
            child: pdfView(),
          ),
        if (widget.appDocument.type == AppFileType.VIDEO)
          Flexible(
            child: _controller.value.initialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: Stack(
                      children: <Widget>[
                        VideoPlayer(_controller),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            color: Colors.black45,
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _controller.value.isPlaying ? _controller.pause() : _controller.play();
                                    });
                                  },
                                  icon: Icon(
                                    _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : LoadingWidget(),
          ),
        if (widget.appDocument.type == AppFileType.FILE)
          Center(
            child: Text(
              'File rendering does not '
              'support on the system of this version',
            ),
          )
      ],
    );
  }

  Future<PDFDocument> getPDF() async {
    File file = await DownloadFile.downloadFile(widget.appDocument.url, widget.appDocument.fileName);
    return PDFDocument.openFile(file.path);
  }

  Widget pdfView() => FutureBuilder<PDFDocument>(
        future: getPDF(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            // Show document
            return PDFView(document: snapshot.data);
          }

          if (snapshot.hasError) {
            // Catch
            return Center(
              child: Text(
                'PDF Rendering does not '
                'support on the system',
              ),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      );

  _showLoading() {
    appLogs("ViewDocumentScreen:_showLoading");
    setState(() => _pageState = PageState.LOADING);
  }

  _hideLoading() {
    appLogs("ViewDocumentScreen:_hideLoading");
    setState(() => _pageState = PageState.LOADED);
  }

  _showError() {
    appLogs("ViewDocumentScreen:_showError");
    setState(() => _pageState = PageState.ERROR);
  }

  @override
  void dispose() {
    if (_controller != null) _controller.dispose();
  }
}
