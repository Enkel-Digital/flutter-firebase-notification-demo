import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './data.dart';
import './message.dart';
import './home.dart' show Home;

void main() {
  final model = DataModel();
  model.syncData();
  model.messages = {
    1: Message(
      id: 1,
      createdAt: 123,
      type: "cm",
      title: "test title",
      preview: "test preview",
      previewImg:
          "https://www.english-efl.com/wp-content/uploads/2019/12/test.jpg",
      message: "test message",
    ),
    2: Message(
      id: 1,
      createdAt: 124,
      type: "cm",
      title: "test title 2",
      preview: "test preview 2",
      previewImg:
          "https://www.english-efl.com/wp-content/uploads/2019/12/test.jpg",
      message: "test message 2",
    ),
    3: Message(
      id: 1,
      createdAt: 125,
      type:
          "a super super super super super super super super super long message type",
      title: "test title 3",
      preview: "test preview 3",
      previewImg:
          "https://www.english-efl.com/wp-content/uploads/2019/12/test.jpg",
      message: "test message 3",
    ),
    4: Message.fromJsonString("""{
                                "id": 4,
                                "createdAt": 200,
                                "type": "cm",
                                "title": "from json title",
                                "preview": "from json preview",
                                "previewImg": "https://www.english-efl.com/wp-content/uploads/2019/12/test.jpg",
                                "message": "from json message"
                              }"""),
  };

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
  Widget build(BuildContext context) => MaterialApp(
        title: "Management Connect",

        // This is the theme of your application.
        theme: ThemeData(primarySwatch: Colors.blue),

        home: const Home(),
      );
}
