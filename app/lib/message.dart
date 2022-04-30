import 'dart:convert';

class Message {
  /// Unique id for every single message
  final int id;

  final int createdAt;
  final String type;
  final String title;
  final String preview;
  final String message;
  final String? previewImg;

  // @todo Figure out how to track this, or maybe this should not be tracked at all?
  // @todo E.g. If user like this post before, and redownload app, will this reset?
  bool liked;

  Message({
    required this.id,
    required this.createdAt,
    required this.type,
    required this.title,
    required this.preview,
    required this.message,
    this.previewImg,

    // Use a default value in the constructor instead of having a default value
    // in the instance variable declaration because if that is set there, then
    // this.liked cannot be set in the constructor as it will override it.
    //
    // This might not be included because if the user is not tracked, then this
    // will always default to being false, and in that case the liked value's
    // initial value should be set at instance variable declaration instead, and
    // this will no longer be a constructor settable value.
    this.liked = false,
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
      id: json['id'],
      createdAt: json['createdAt'],
      type: json['type'],
      title: json['title'],
      preview: json['preview'],
      message: json['message'],

      /* Optional values */
      previewImg: json['previewImg'],

      // See notes on this.liked in the constructor
      //
      // Return false if it is null because if it is null, then it will override
      // the default value in the constructor, which attempts to set it to null,
      // which is not allowed because of the `bool` type of liked property.
      liked: json['liked'] ?? false,
    );
  }
}
