import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert'; // For base64 encoding (optional)
import '../custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'dart:convert';
import '../repositories/payment_repository.dart';
import '../my_theme.dart';  
import '../app_config.dart';
import '../screens/order_list.dart';
import '../screens/wallet.dart';
import '../helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FileUploadWebView extends StatefulWidget {
  @override
  _FileUploadWebViewState createState() => _FileUploadWebViewState();
}

class _FileUploadWebViewState extends State<FileUploadWebView> {
  late final WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).seller_area,
        style: TextStyle(fontSize: 14, color: MyTheme.accent_color),)),
      body: WebView(
        initialUrl: "${AppConfig.BASE_URL}/users/login-app", 
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          _controller = controller;
        },
        javascriptChannels: {
          JavascriptChannel(
            name: 'FlutterFilePicker',
            onMessageReceived: (message) async {
              await _pickFileAndSendToWebView();
            },
          ),
        },
      ),
    );
  }

  Future<void> _pickFileAndSendToWebView() async {
    // Use the file picker to let the user select a file
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      final fileBytes = result.files.first.bytes;
      final fileName = result.files.first.name;

      // Encode the file into base64 (if needed for your upload logic)
      final base64File = base64Encode(fileBytes!);

      // Inject the file data back into the WebView (JavaScript or HTTP upload)
      _controller.runJavascript("""
        document.getElementById('yourFileInputElement').value = "$base64File";
        document.getElementById('yourFileInputElement').dispatchEvent(new Event('change'));
      """);
    }
  }
}
