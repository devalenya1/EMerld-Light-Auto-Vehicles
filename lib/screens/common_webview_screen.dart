
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:file_picker/file_picker.dart';
import '../helpers/shared_value_helper.dart';
import '../my_theme.dart';

class CommonWebviewScreen extends StatefulWidget {
  final String url;
  final String page_name;

  CommonWebviewScreen({Key key, this.url = "", this.page_name = ""})
      : super(key: key);

  @override
  _CommonWebviewScreenState createState() => _CommonWebviewScreenState();
}

class _CommonWebviewScreenState extends State<CommonWebviewScreen> {
  late InAppWebViewController _webViewController;
  final GlobalKey webViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return SizedBox.expand(
      child: InAppWebView(
        key: webViewKey,
        initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            javaScriptEnabled: true,
            javaScriptCanOpenWindowsAutomatically: true,
            mediaPlaybackRequiresUserGesture: false,
          ),
          android: AndroidInAppWebViewOptions(
            useHybridComposition: true,
          ),
          ios: IOSInAppWebViewOptions(
            allowsInlineMediaPlayback: true,
          ),
        ),
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
        onConsoleMessage: (controller, consoleMessage) {
          debugPrint(consoleMessage.message);
        },
        onReceivedServerTrustAuthRequest: (controller, challenge) async {
          return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
        },
        androidOnPermissionRequest: (controller, origin, resources) async {
          return PermissionRequestResponse(
            resources: resources,
            action: PermissionRequestResponseAction.GRANT,
          );
        },
        onReceivedHttpAuthRequest: (controller, challenge) async {
          return HttpAuthResponse(action: HttpAuthResponseAction.PROCEED);
        },
        androidOnGeolocationPermissionsShowPrompt: (controller, origin) async {
          return GeolocationPermissionShowPromptResponse(
            origin: origin,
            allow: true,
            retain: true,
          );
        },
        // onReceivedError: (controller, request, error) {
        //   debugPrint('Error: ${error.description}');
        // },
        onLoadStop: (controller, url) async {
          debugPrint('Page finished loading: $url');
        },
        onLoadHttpError: (controller, url, statusCode, description) {
          debugPrint('HTTP error: $statusCode, $description');
        },
        onDownloadStart: (controller, url) async {
          // Handle file download, if required
          debugPrint("Download started: $url");
        },
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        widget.page_name,
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  // File picking logic
  Future<List<String>?> pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: false);
      return result?.files.map((file) => file.path ?? "").toList();
    } catch (e) {
      debugPrint("File picking error: $e");
      return null;
    }
  }

  // Handle file upload using JavaScript and trigger it from the webview
  Future<void> handleFileUpload() async {
    // Create a JavaScript function to trigger the file input element
    await _webViewController.evaluateJavascript(source: """
      var input = document.createElement('input');
      input.type = 'file';
      input.click();
      input.onchange = function(event) {
        var files = event.target.files;
        if (files.length > 0) {
          // Handle the file uploading logic here
        }
      };
    """);
  }
}
