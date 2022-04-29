import 'dart:convert';

class Message {
  final int createdAt;
  final String type;
  final String title;
  final String preview;
  final String message;
  final String? previewImg;

  const Message({
    required this.createdAt,
    required this.type,
    required this.title,
    required this.preview,
    required this.message,
    this.previewImg,
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
        type: json['type'],
        title: json['title'],
        preview: json['preview'],
        previewImg: json['previewImg'],
        message: json['message']);
  }
}
