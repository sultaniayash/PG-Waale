import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:qbix/components/app_components.dart';
import 'package:qbix/theme/app_colors.dart';
import 'package:qbix/theme/app_theme.dart';
import 'package:qbix/utils/a_utils.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QWCodeScreen extends StatefulWidget {
  final Function(String) callback;
  final String title;
  final String subTitle;

  const QWCodeScreen({Key key, @required this.callback, @required this.title, @required this.subTitle})
      : super(key: key);

  @override
  _QWCodeScreenState createState() => _QWCodeScreenState();
}

class _QWCodeScreenState extends State<QWCodeScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalObjectKey<ScaffoldState>(generateDbId());
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');

  PageState _pageState = PageState.LOADED;
  String message = "";

  QRViewController _controller;

  @override
  void initState() {
    super.initState();
    appLogs("QWCodeScreen", tag: "Screen");
    Future.delayed(Duration(milliseconds: Constants.delaySmall), () => getQWCodeScreenDetails());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  getQWCodeScreenDetails() async {
    hideLoading();
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
    });
    _controller.scannedDataStream.listen((scanData) {
      if (scanData.contains(Constants.qrCodePrefix)) {
        showLoading();
        _controller.pauseCamera();
        widget.callback(scanData);
      } else {
        AppToast.showMessage(Strings.invalidQR);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarCustom(title: widget.title, leading: AppBackButton(), actions: [
        IconButton(
          icon: Icon(
            Icons.switch_camera,
            color: Colors.white,
          ),
          onPressed: () {
            try {
              _controller?.flipCamera();
            } on Exception catch (e) {
              appLogs(e);
            }
          },
        )
      ]),
      backgroundColor: Colors.white,
      body: ConnectivityWidgetWrapper(
        alignment: Alignment.topCenter,
        color: AppColors.primary,
        disableInteraction: true,
        child: Stack(
          children: <Widget>[
            getBody(),
            ScreenLoader(pageState: _pageState),
            AppErrorWidget(
              message: message,
              pageState: _pageState,
              onTap: () => getQWCodeScreenDetails(),
            )
          ],
        ),
      ),
    );
  }

  Widget getBody() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(Sizes.s40),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  widget.subTitle,
                  style: TextStyles.defaultSemiBold.copyWith(color: Colors.black38),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 5,
          child: ConnectivityWidgetWrapper(
            alignment: Alignment.topCenter,
            color: AppColors.primary,
            disableInteraction: true,
            stacked: false,
            offlineWidget: Container(
              color: Colors.black,
              child: Placeholder(
                color: AppColors.primary,
              ),
            ),
            child: QRView(
              key: _qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        ),
      ],
    );
  }

  showLoading() {
    appLogs("QWCodeScreen:showLoading");

    setState(() => _pageState = PageState.LOADING);
  }

  hideLoading() {
    appLogs("QWCodeScreen:hideLoading");

    setState(() => _pageState = PageState.LOADED);
  }

  showError() {
    appLogs("QWCodeScreen:showError");

    setState(() => _pageState = PageState.ERROR);
  }
}
