import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CommonWebviewScreen extends StatefulWidget {
  final String url;
  final String page_name;

  CommonWebviewScreen({Key key, this.url = "", this.page_name = ""})
      : super(key: key);

  @override
  _CommonWebviewScreenState createState() => _CommonWebviewScreenState();
}

class _CommonWebviewScreenState extends State<CommonWebviewScreen> {
  InAppWebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.page_name,
          style: TextStyle(fontSize: 16, color: Colors.blue),
        ),
        elevation: 0.0,
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            mediaPlaybackRequiresUserGesture: false,
            javaScriptEnabled: true,
          ),
        ),
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
        onConsoleMessage: (controller, consoleMessage) {
          print(consoleMessage.message);
        },
      ),
    );
  }
}
