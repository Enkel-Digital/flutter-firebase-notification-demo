/// Module for the DataModel / state management logic of the app.

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import './message.dart';

/// DataModel is the central state store of the application, kinda like vuex.
/// [ChangeNotifier] is a class in `flutter:foundation`
class DataModel with ChangeNotifier {
  // @todo Make this a singleton
  DataModel();

  int lastSync = 0;

  // @todo Hydrate this with data in local storage on load
  Map<int, Message> messages = {};
  String? filterBy;

  /// Getter for messages as a sorted List from latest message to oldest message.
  //
  // The sort function sorts from smallest to biggest,
  // and Comparator function to return negative number if m1 is smaller than m2.
  // Since the first message should be the latest message (biggest createdAt),
  // then we should return negative number if m1 is newer than m2.
  List<Message> get sortedMsgs =>
      messages.values.toList()..sort((m1, m2) => m2.createdAt - m1.createdAt);

  /// Getter for messages, filtered if `filterBy` is not null
  List<Message> get msgs => filterBy == null
      ? sortedMsgs
      : sortedMsgs.where((msg) => msg.type == filterBy).toList();

  /// Getter for the mapping of message types to number of messages for that type.
  //
  // Fold messages to count how many messages per type.
  // Reference: https://stackoverflow.com/a/66492956
  Map<String, int> get messageTypes => sortedMsgs.fold(
      <String, int>{},
      (Map<String, int> map, msg) =>
          map..update(msg.type, (count) => count + 1, ifAbsent: () => 1));

  /// Getter for string formatted last sync time
  String get lastSyncTimeString => DateFormat('E, MMM d y, h:mma').format(
      DateTime.fromMillisecondsSinceEpoch(lastSync * 1000, isUtc: true)
          .toLocal());

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

  /// Method to like a message
  void likeMessage(int messageID) {
    // Optimistic UI updates, also this is not a critical use case so it is fine
    // to update the UI and leave it as is even if the API call fails later on.
    //
    // Toggle liked bool and return the modified message instance
    messages.update(messageID, (message) {
      message.liked = !message.liked;
      return message;
    });

    // @todo Call API

    // Rebuild widgets
    notifyListeners();
  }
}
