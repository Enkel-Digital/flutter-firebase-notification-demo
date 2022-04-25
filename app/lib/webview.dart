import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BasicWebView extends StatelessWidget {
  final String message;

  const BasicWebView({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'about:blank',
      onWebViewCreated: (WebViewController webViewController) {
        webViewController.loadUrl(Uri.dataFromString(createHTML(message),
                mimeType: 'text/html', encoding: Encoding.getByName("utf-8"))
            .toString());
      },
    );
  }
}

// Inject message value into the HTML body and return the whole HTML
String createHTML(String message) {
  return """
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset='utf-8'>
        <meta name='viewport' content='width=device-width, initial-scale=1'>
    </head>
    <body>
        $message
    </body>
    </html>
    """;
}
