/// Module for the Home screen widgets.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import './data.dart';
import './drawer.dart';
import './message.dart';
import './webview.dart';

/// This is the Home Screen widget
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          // Show the current message type + number of messages of that type as the title
          title: Consumer<DataModel>(
              builder: (context, dataModel, child) => Text(dataModel.filterBy ==
                      null
                  ? 'Management Connect (${dataModel.messages.length})'
                  : '${dataModel.filterBy} (${dataModel.messageTypes[dataModel.filterBy]})')),

          actions: [
            IconButton(
              onPressed: () => context.read<DataModel>().syncData(),
              icon: const Icon(Icons.restart_alt),
            )
          ],
        ),
        drawer: const HomeDrawer(),
        body: const ListOfMsgs(),
      );
}

/// Home scree page widget that shows all the Message previews.
/// This widget maps a list of messages to a ListView of Message Preview widgets,
/// which can be of type `MessagePreview` or `BigMessagePreview`
class ListOfMsgs extends StatelessWidget {
  const ListOfMsgs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<DataModel>(
        // ListView.seperated only builds the item and separator when visible
        builder: (context, dataModel, child) => ListView.separated(
          padding: const EdgeInsets.all(10),
          itemCount: dataModel.msgs.length,

          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),

          // Return different widget for the first message, aka the latest message
          itemBuilder: (BuildContext context, int index) => (index == 0)
              ? BigMessagePreview(message: dataModel.msgs[index])
              : MessagePreview(message: dataModel.msgs[index]),
        ),
      );
}

/// Card widget that shows the preview of a message.
class MessagePreview extends StatelessWidget {
  final Message message;

  const MessagePreview({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // @todo TMP: Set true to allow word wrap and set false to prevent word wrap to single line
    // ignore: dead_code
    const overflow = false ? TextOverflow.visible : TextOverflow.ellipsis;

    return GestureDetector(
      // Open WebView widget on top or Home widget on clicking an item
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BasicWebView(message: message))),

      child: Card(
        child: message.previewImg == null
            ?
            // Card without a previewImg shown
            Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(message.title,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            overflow: overflow)),
                    Text(message.preview,
                        style: const TextStyle(overflow: overflow)),

                    // Spacing
                    const Divider(),

                    // Show the date when the message was created
                    Text(
                      DateFormat('E, MMMM d, y').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              message.createdAt * 1000)),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ))
            :
            // Card with a previewImg shown
            Row(
                children: [
                  Image(
                    image: NetworkImage(message.previewImg!),
                    loadingBuilder: (context, child, loadingProgress) =>
                        loadingProgress == null
                            ? child
                            : const CircularProgressIndicator(),
                    fit: BoxFit.fitWidth,
                    // Picture can only take up 30% of screen width
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),

                  // Text beside the image
                  SizedBox(
                      // The rest of the words should only take up 60% of screen width
                      // Calculated by (Row - 0.3) - someForPadding
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(message.title,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    overflow: overflow)),
                            Text(message.preview,
                                style: const TextStyle(overflow: overflow)),

                            // Spacing
                            const Divider(),

                            // Show the date when the message was created
                            Text(
                              DateFormat('E, MMMM d, y').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      message.createdAt * 1000)),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
      ),
    );
  }
}

/// Card widget that shows the preview of the first message in a list as bigger
/// then the normal preview widget to show emphasis on the first message.
class BigMessagePreview extends StatelessWidget {
  final Message message;

  const BigMessagePreview({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        // Open WebView widget on top or Home widget on clicking an item
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BasicWebView(message: message))),

        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                message.previewImg == null
                    ? const SizedBox.shrink()
                    : Image(
                        image: NetworkImage(message.previewImg!),
                        loadingBuilder: (context, child, loadingProgress) =>
                            loadingProgress == null
                                ? child
                                : const CircularProgressIndicator(),
                        fit: BoxFit.contain,

                        // @todo Use a max-height or smth to limit height to 50%
                        // of screen or less. However if that happens, then there
                        // will be empty bars at the side of the image due to the
                        // `BoxFit.contain`. Alternatively, advice users to only
                        // upload pictures of an appropriate height?
                        // height: MediaQuery.of(context).size.height,
                      ),

                // Spacing
                const SizedBox(height: 14),

                // Show the date when the message was created
                Text(DateFormat('E, MMMM d, y').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        message.createdAt * 1000))),

                // Spacing
                const Divider(),

                Text(
                  message.title,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),

                // Spacing
                const SizedBox(height: 14),

                Text(
                  message.preview,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
}
