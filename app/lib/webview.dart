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
                elevation: 8,
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
              elevation: 8,
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

        // Problem:
        // Because of the floating button, some webview content can be blocked.
        //
        // Solution 1:
        // Contain the body/webview in a SizedBox and set a height e.g. 80%,
        // this will not work as the bottom part of the screen is not used at all,
        // and it is also not scrollable. The bottom part of the screen should
        // still be usable just that we want the user to be able to scroll past.
        //
        // Solution 2:
        // Add an arbitrary number of <br /> to the bottom of the HTML template
        // after the message so that users can scroll past it. However it is hard
        // to determine this value as not all screen sizes render the number of
        // br elements the same way.
        //
        // Solution 3:
        // Add something like <div style="min-height: 48px;"></div> to the bottom
        // of the HTML template, as the default height of Icons is 48px, making it
        // more accurate then the br element method.
        //
        // *Solution 3 is the one used right now!
        floatingActionButton: FAB(message: message),
      );
}

/// Utility function to inject message value into HTML body and return the whole HTML
// This can be inlined explicitly, but just looks nicer when written this way :)
// Alternatively, @pragma('vm:prefer-inline') can be used, but this is untested.
// See explaination in FAB section of webview widget for the extra div.
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

        <div style="min-height: 48px;"></div>
    </body>
    </html>
    """;
