import 'package:flutter/material.dart';

import './message.dart';
import './webview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final List<Message> messages = [
      const Message(
        createdAt: 123,
        title: "test title",
        preview: "test preview",
        message: "test message",
      ),
      const Message(
        createdAt: 124,
        title: "test title 2",
        preview: "test preview 2",
        message: "test message 2",
      ),
      const Message(
        createdAt: 125,
        title: "test title 3",
        preview: "test preview 3",
        message: "test message 3",
      ),
      Message.fromJsonString("""{
                                "createdAt": 200,
                                "title": "from json title",
                                "preview": "from json preview",
                                "message": "from json message"
                              }"""),
    ];

    return MaterialApp(
      title: "Commissioner's App",

      // This is the theme of your application.
      theme: ThemeData(primarySwatch: Colors.blue),

      home: Scaffold(
          appBar: AppBar(title: const Text("Commissioner's App")),
          body: Center(child: ListOfMsgs(messages: messages))),
    );
  }
}

class MessagePreview extends StatelessWidget {
  final Message message;

  const MessagePreview({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Container(
    // height: 50,
    // color: Colors.grey,
    return TextButton(
      child: Center(child: Text('inside msg preview: ${message.preview}')),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BasicWebView(message: message.message)),
        );
      },
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
        return MessagePreview(message: messages[index]);
      },
    );
  }
}
