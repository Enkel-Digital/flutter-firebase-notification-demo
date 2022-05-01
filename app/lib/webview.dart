import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';

import './message.dart';
import './data.dart';

/// The Floating Action Buttons (like and comment) at the bottom of the screen.
class FAB extends StatelessWidget {
  final Message message;

  const FAB({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<DataModel>(
        builder: (context, dataModel, child) => Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Only show Comment FAB if it is not of this type
            if (message.type != "__SPECIAL_MESSAGE_TYPE__")
              Material(
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                elevation: 4.0,
                child: IconButton(
                  icon: const Icon(Icons.comment),

                  // ignore: avoid_print
                  onPressed: () => print("Comments"),
                ),
              ),

            const SizedBox(width: 14),

            Material(
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              elevation: 4.0,
              child: IconButton(
                icon: dataModel.messages[message.id]!.liked == true
                    ? const Icon(Icons.favorite, color: Colors.red)
                    : const Icon(Icons.favorite_border),
                onPressed: () => dataModel.likeMessage(message.id),
              ),
            ),
          ],
        ),
      );
}

class BasicWebView extends StatelessWidget {
  final Message message;

  const BasicWebView({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(message.title),
        ),
        body: WebView(
            initialUrl: Uri.dataFromString(
                    createHTML(Uri.decodeComponent(message.message)),
                    mimeType: 'text/html',
                    encoding: Encoding.getByName("utf-8"))
                .toString()),
        floatingActionButton: FAB(message: message),
      );
}

/// Utility function to inject message value into HTML body and return the whole HTML
// This can be inlined explicitly, but just looks nicer when written this way :)
// Alternatively, @pragma('vm:prefer-inline') can be used, but this is untested.
String createHTML(final String message) => """
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
