import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:grouped_list/grouped_list.dart';

class Comment {
  final int createdAt;
  // A UUID of the user device or smth? Since we have no login..
  final String sentBy;
  final String msg;

  const Comment({
    required this.createdAt,
    required this.sentBy,
    required this.msg,
  });
}

/// Utility function for hardcoded data generation
int getNow() => (DateTime.now().millisecondsSinceEpoch / 1000).truncate();

/// Utility function
String fromUnixS(int time) => DateFormat('E, MMM d y, h:mma').format(
    DateTime.fromMillisecondsSinceEpoch(time * 1000, isUtc: true).toLocal());

class CommentSection extends StatefulWidget {
  const CommentSection({Key? key}) : super(key: key);

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  /// Hardcoded data to test UI
  List<Comment> comments = [
    Comment(createdAt: getNow() - 1500, sentBy: "me", msg: "test"),
    Comment(createdAt: getNow() - 1400, sentBy: "others", msg: "test"),
    Comment(createdAt: getNow() - 1300, sentBy: "others", msg: "test"),
    Comment(createdAt: getNow() - 1200, sentBy: "me", msg: "test"),
    Comment(createdAt: getNow() - 1100, sentBy: "me", msg: "test"),
    Comment(createdAt: getNow() - 1000, sentBy: "me", msg: "test"),
    Comment(createdAt: getNow() - 900, sentBy: "me", msg: "test"),
    Comment(createdAt: getNow() - 800, sentBy: "others", msg: "test"),
    Comment(createdAt: getNow() - 700, sentBy: "me", msg: "test"),
    Comment(createdAt: getNow() - 600, sentBy: "others", msg: "test"),
    Comment(createdAt: getNow() - 500, sentBy: "me", msg: "test"),
    Comment(createdAt: getNow() - 400, sentBy: "me", msg: "test"),
    Comment(createdAt: getNow() - 300, sentBy: "others", msg: "test"),
    Comment(createdAt: getNow() - 200, sentBy: "others", msg: "test"),
    Comment(createdAt: getNow() - 100, sentBy: "me", msg: "test"),
  ];

  @override
  Widget build(BuildContext context) {
    // Show loading screen to fake it for a while before showing the comments
    // comments are only loaded ephermerally within this widget on open
    // once complete, widget cosing disposes of all the loaded comments too

    return Scaffold(
      appBar: AppBar(title: const Text("Comments")),
      body: Column(
        children: [
          // Expanded widget to show the messages so that it will take up as much
          // height as possible, pushing the text input widget to the bottom of
          // the screen even if there is not enough messages to do so.
          Expanded(
            child: GroupedListView<Comment, DateTime>(
              reverse: true,
              order: GroupedListOrder.DESC,
              useStickyGroupSeparators: true,
              floatingHeader: true,

              padding: const EdgeInsets.all(14),
              elements: comments,

              // Group the comments by time
              groupBy: (comment) => DateTime.fromMillisecondsSinceEpoch(
                      comment.createdAt * 1000,
                      isUtc: true)
                  .toLocal(),

              groupHeaderBuilder: (comment) => const SizedBox(),

              itemBuilder: (context, Comment comment) => Align(
                // Tmp solution to show messages sent by the user on the right
                alignment: comment.sentBy == "me"
                    ? Alignment.centerRight
                    : Alignment.centerLeft,

                // The message card itself
                child: Card(
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child:
                        // @todo Add who is it sent by
                        // Split into 2 Text objects and format them differently
                        Text('${comment.msg}\n${fromUnixS(comment.createdAt)}'),
                  ),
                ),
              ),
            ),
          ),

          // Text input itself
          Container(
            color: Colors.grey.shade300,
            child: TextInput(
              onSubmit: (text) => setState(
                () => comments
                    .add(Comment(createdAt: getNow(), sentBy: "me", msg: text)),
              ),
            ),
          )
        ],
      ),
    );
  }
}

/// Text input widget to handle the clearing of text within.
class TextInput extends StatelessWidget {
  final Function(String) onSubmit;

  const TextInput({Key? key, required this.onSubmit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return TextField(
      controller: controller,

      // Not very intuitive as user might just want to see the messages first
      //instead of commenting immediately, and this makes the UI jumpy.
      // autofocus: true,

      decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(14),
          hintText: "Type your comments here..."),

      // Wrapper around the actual onSubmit callback function,
      // to help clear text automatically after onSubmit is ran.
      onSubmitted: (text) {
        onSubmit(text);
        controller.clear();
      },
    );
  }
}
