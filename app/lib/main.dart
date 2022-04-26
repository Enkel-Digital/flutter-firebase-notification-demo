import 'package:flutter/material.dart';

import './message.dart';
import './webview.dart';

void main() {
  final messages = [
    const Message(
      createdAt: 123,
      title: "test title",
      preview: "test preview",
      previewImg:
          "https://www.english-efl.com/wp-content/uploads/2019/12/test.jpg",
      message: "test message",
    ),
    const Message(
      createdAt: 124,
      title: "test title 2",
      preview: "test preview 2",
      previewImg:
          "https://www.english-efl.com/wp-content/uploads/2019/12/test.jpg",
      message: "test message 2",
    ),
    const Message(
      createdAt: 125,
      title: "test title 3",
      preview: "test preview 3",
      previewImg:
          "https://www.english-efl.com/wp-content/uploads/2019/12/test.jpg",
      message: "test message 3",
    ),
    Message.fromJsonString("""{
                                "createdAt": 200,
                                "title": "from json title",
                                "preview": "from json preview",
                                "previewImg": "https://www.english-efl.com/wp-content/uploads/2019/12/test.jpg",
                                "message": "from json message"
                              }"""),
  ];

  runApp(Home(messages: messages));
}

// This is the root widget of the application
class Home extends StatelessWidget {
  final List<Message> messages;

  const Home({Key? key, required this.messages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Management Connect",

      // This is the theme of your application.
      theme: ThemeData(primarySwatch: Colors.blue),

      home: Scaffold(
        appBar: AppBar(
          title: const Text("Management Connect"),
        ),
        body: Center(child: ListOfMsgs(messages: messages)),
      ),
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
              builder: (context) => BasicWebView(message: message.message))),

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
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

class BigMessagePreview extends StatelessWidget {
  final Message message;

  const BigMessagePreview({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BasicWebView(message: message.message)),
      ),
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
  final List<Message> messages;

  const ListOfMsgs({Key? key, required this.messages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        // Return different widget for the first message, aka the latest message
        if (index == 0) {
          return BigMessagePreview(message: messages[index]);
        }

        return MessagePreview(message: messages[index]);
      },
    );
  }
}
