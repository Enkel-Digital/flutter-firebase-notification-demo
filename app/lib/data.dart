/// Module for the DataModel / state management logic of the app.
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import './message.dart';

/// [ChangeNotifier] is a class in `flutter:foundation`
/// [DataModel] does NOT depend on Provider.
class DataModel with ChangeNotifier {
  // @todo Make this a singleton
  DataModel();

  int lastSync = 0;
  List<Message> messages = [];
  String? filterBy;

  /// Getter for messages, filtered if `filterBy` is not null
  List<Message> get msgs => filterBy == null
      ? messages
      : messages.where((msg) => msg.type == filterBy).toList();

  /// Getter for string formatted last sync time
  String get lastSyncTimeString => DateFormat('E, MMM d y, h:mma').format(
      DateTime.fromMillisecondsSinceEpoch(lastSync * 1000, isUtc: true)
          .toLocal());

  /// Getter for the mapping of message types to number of messages for that type.
  ///
  /// Fold messages to count how many messages per type.
  /// Reference: https://stackoverflow.com/a/66492956
  Map<String, int> get messageTypes => messages.fold(
      <String, int>{},
      (Map<String, int> map, msg) =>
          map..update(msg.type, (count) => count + 1, ifAbsent: () => 1));

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

    // @todo TMP Demo logic
    lastSync = (DateTime.now().millisecondsSinceEpoch / 1000).truncate();

    // Rebuild widgets
    notifyListeners();
  }

  /// Method to update filterBy value
  void filterWith(String? messageType) {
    // @todo Check if the string is valid against all the message types

    filterBy = messageType;

    // Rebuild widgets
    notifyListeners();
  }
}

}
