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
  InAppWebViewController _webViewController;
  final GlobalKey webViewKey = GlobalKey();

  // @override
  // void initState() {
  //   super.initState();
  //   requestPermissions();
  // }

  // Future<void> requestPermissions() async {
  //   // Request necessary permissions
  //   Map<Permission, PermissionStatus> statuses = await [
  //     Permission.storage,
  //     Permission.camera,
  //     Permission.microphone,
  //   ].request();

  //   // Check individual permissions
  //   if (statuses[Permission.camera] != PermissionStatus.granted) {
  //     debugPrint("Camera permission not granted");
  //   }
  //   if (statuses[Permission.microphone] != PermissionStatus.granted) {
  //     debugPrint("Microphone permission not granted");
  //   }
  //   if (statuses[Permission.storage] != PermissionStatus.granted) {
  //     debugPrint("Storage permission not granted");
  //   }
  // }

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
        androidOnPermissionRequest: (controller, origin, resources) async {
          // if (resources.contains('android.webkit.resource.VIDEO_CAPTURE')) {
          //   // Handle camera permission
          //   await Permission.camera.request();
          // }
          // if (resources.contains('android.webkit.resource.AUDIO_CAPTURE')) {
          //   // Handle microphone permission
          //   await Permission.microphone.request();
          // }
          // if (resources.contains('android.webkit.resource.PROTECTED_MEDIA_ID')) {
          //   // Handle storage permission
          //   await Permission.storage.request();
          // }

          return PermissionRequestResponse(
            resources: resources,
            action: PermissionRequestResponseAction.GRANT,
          );
        },
        onConsoleMessage: (controller, consoleMessage) {
          debugPrint(consoleMessage.message);
        },
        onReceivedServerTrustAuthRequest: (controller, challenge) async {
          return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
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
        onLoadStop: (controller, url) async {
          debugPrint('Page finished loading: $url');
        },
        onLoadHttpError: (controller, url, statusCode, description) {
          debugPrint('HTTP error: $statusCode, $description');
        },
        onDownloadStart: (controller, url) async {
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

  Future<List<String>> pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: false);
      return result?.files.map((file) => file.path ?? "").toList();
    } catch (e) {
      debugPrint("File picking error: $e");
      return mull;
    }
  }

  Future<void> handleFileUpload() async {
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

