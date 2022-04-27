import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        title: const Text("Management Connect"),
        actions: [
          IconButton(
            onPressed: () => context.read<DataModel>().syncData(),
            icon: const Icon(Icons.restart_alt),
          )
        ],
      ),
      drawer: const HomeDrawer(),
      body: const Center(child: ListOfMsgs()),
    );
  }
}

class MessagePreview extends StatelessWidget {
  final Message message;

  const MessagePreview({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              fit: BoxFit.fitWidth,
              // Picture can only take up 30% of screen width
              width: MediaQuery.of(context).size.width * 0.3,
            ),

            //
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  // Spacing
                  const SizedBox(height: 16),

                  Text(
                    message.preview,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            )
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
                fit: BoxFit.contain,
                // fit: BoxFit.fitHeight,
              ),

              Text(
                message.title,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              // Spacing
              const SizedBox(height: 16),

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

class ListOfMsgs extends StatelessWidget {
  const ListOfMsgs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<DataModel>(
        builder: (context, dataModel, child) => ListView.separated(
          padding: const EdgeInsets.all(10),
          itemCount: dataModel.messages.length,

          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),

          // Return different widget for the first message, aka the latest message
          itemBuilder: (BuildContext context, int index) => (index == 0)
              ? BigMessagePreview(message: dataModel.messages[index])
              : MessagePreview(message: dataModel.messages[index]),
        ),
      );
}
