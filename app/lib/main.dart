import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import './data.dart';
import './drawer.dart';
import './message.dart';
import './webview.dart';

void main() {
  final model = DataModel();
  model.messages = [
    const Message(
      createdAt: 123,
      type: "cm",
      title: "test title",
      preview: "test preview",
      previewImg:
          "https://www.english-efl.com/wp-content/uploads/2019/12/test.jpg",
      message: "test message",
    ),
    const Message(
      createdAt: 124,
      type: "cm",
      title: "test title 2",
      preview: "test preview 2",
      previewImg:
          "https://www.english-efl.com/wp-content/uploads/2019/12/test.jpg",
      message: "test message 2",
    ),
    const Message(
      createdAt: 125,
      type:
          "a super super super super super super super super super long message type",
      title: "test title 3",
      preview: "test preview 3",
      previewImg:
          "https://www.english-efl.com/wp-content/uploads/2019/12/test.jpg",
      message: "test message 3",
    ),
    Message.fromJsonString("""{
                                "createdAt": 200,
                                "type": "cm",
                                "title": "from json title",
                                "preview": "from json preview",
                                "previewImg": "https://www.english-efl.com/wp-content/uploads/2019/12/test.jpg",
                                "message": "from json message"
                              }"""),
  ];

  runApp(
    // Provide the model to all widgets within the app. We're using
    // ChangeNotifierProvider because that's a simple way to rebuild
    // widgets when a model changes. We could also just use
    // Provider, but then we would have to listen to Counter ourselves.
    //
    // Read Provider's docs to learn about all the available providers.
    ChangeNotifierProvider(
      // Initialize model in the builder so that Provider can own Model's
      // lifecycle, making sure to call `dispose` when not needed anymore.
      create: (context) => model,

      child: const App(),
    ),
  );
}

/// This is the root widget of the application
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Management Connect",

      // This is the theme of your application.
      theme: ThemeData(primarySwatch: Colors.blue),

      home: const Home(),
    );
  }
}

/// This is the Home Screen widget
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
}

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
        child: Row(
          children: [
            Image(
              image: NetworkImage(message.previewImg),
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

class BigMessagePreview extends StatelessWidget {
  final Message message;

  const BigMessagePreview({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
              Image(
                image: NetworkImage(message.previewImg),
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress == null
                        ? child
                        : const CircularProgressIndicator(),
                fit: BoxFit.contain,
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
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
}

/// This widget maps a list of messages to a ListView of Message Preview widgets,
/// which can be of type `MessagePreview` or `BigMessagePreview`
class ListOfMsgs extends StatelessWidget {
  const ListOfMsgs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<DataModel>(
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
