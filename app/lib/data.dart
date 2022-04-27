import 'package:flutter/foundation.dart';

import './message.dart';

/// [ChangeNotifier] is a class in `flutter:foundation`
/// [DataModel] does NOT depend on Provider.
class DataModel with ChangeNotifier {
  int lastSync = 0;
  List<Message> messages = [];

  // @todo Make this a singleton
  DataModel();

  // Factory function to create Message object from a json string
  // factory DataModel.fromJsonString(String jsonString) {
  //   final Map<String, dynamic> json = jsonDecode(jsonString);
  //   return DataModel(
  //       lastSync: json['lastSync'], messages: json['messages'].cast<Message>());
  // }

  // Map<String, dynamic> toJson() => {
  //       'lastSync': lastSync,
  //       'messages': messages,
  //     };
  // String toJsonString() => jsonEncode({
  //       'lastSync': lastSync,
  //       'messages': messages,
  //     });

  /// Method to call API to sync for new data
  void syncData() {
    // Call API

    // Update instance data

    // Rebuild widgets
    notifyListeners();
  }
}