import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import './message.dart';

class BasicWebView extends StatelessWidget {
  final Message message;

  const BasicWebView({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(message.title),
        ),
        body: WebView(
            initialUrl: Uri.dataFromString(createHTML(message.message),
                    mimeType: 'text/html',
                    encoding: Encoding.getByName("utf-8"))
                .toString()));
  }
}

// Utility function to inject message value into the HTML body and return the whole HTML
String createHTML(final String uriEncodedMessage) {
  final message = Uri.decodeComponent(uriEncodedMessage);
  return """
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset='utf-8'>
        <meta name='viewport' content='width=device-width, initial-scale=1'>
        
        <!-- @todo Might download it directly to reduce network usage -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/water.css@2/out/light.css"> 
        <!--
        -->
        
        <style>
            body {
                margin: 1em;
            }
        </style>
    </head>
    <body>
        $message
    </body>
    </html>
    """;
}
