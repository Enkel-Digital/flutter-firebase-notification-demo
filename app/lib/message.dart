import 'dart:convert';

class Message {
  final int createdAt;
  final String title;
  final String preview;
  final String previewImg;
  final String message;

  const Message({
    required this.createdAt,
    required this.title,
    required this.preview,
    required this.previewImg,
    required this.message,
  });

  // Keep named constructor to allow user to construct using json map
  // Message.fromJson(Map<String, dynamic> json)
  //     : createdAt = json['createdAt'],
  //       title = json['title'],
  //       preview = json['preview'],
  //       message = json['message'];

  // Factory function to create Message object from a json string
  factory Message.fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return Message(
        createdAt: json['createdAt'],
        title: json['title'],
        preview: json['preview'],
        previewImg: json['previewImg'],
        message: json['message']);
  }
}
