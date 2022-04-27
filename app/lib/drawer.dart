import 'package:flutter/material.dart';

import './message.dart';
import './settings.dart';

/// Drawer widget
class HomeDrawer extends StatelessWidget {
  final List<Message> messages;

  const HomeDrawer({Key? key, required this.messages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fold messages to count how many messages per type
    // Note that this runs every single time drawer is opened
    // Reference: https://stackoverflow.com/a/66492956
    //
    // Then create a list of widgets with the map of "message type to count"
    final messageTypes = messages
        .fold(
            <String, int>{},
            (Map<String, int> map, msg) =>
                map..update(msg.type, (count) => count + 1, ifAbsent: () => 1))
        .entries
        .map((entry) => ListTile(
            // @todo Pick a nicer icon
            leading: const Icon(Icons.indeterminate_check_box),
            title: Text(entry.key),
            trailing: Text(entry.value.toString()),
            onTap: () {
              // Update the state of the app.
              // ...
              // Then close the drawer
              Navigator.pop(context);
            }))
        .toList();

    return Drawer(
      // ListView lets users scroll through options even if there isn't enough vertical space
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,

        // 1. All messages
        // Divider that says, 'filter by'
        // 2. Message type $X
        // 3. Message type $X
        children: [
          // @todo Add app logo here
          const DrawerHeader(
            // @todo Use theme color instead of manually setting it here
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Drawer Header'),
          ),

          // Default home page route
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Show all Messages'),
            onTap: () {
              // Update the state of the app.
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),

          // Filter by divider
          const Divider(color: Colors.grey),

          // Filter by Header
          const ListTile(
            leading: Icon(Icons.sort),
            title: Text('Filter Message Types',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),

          // Programmatically generated message type widgets
          ...messageTypes,

          const Divider(color: Colors.grey),

          // Settings tile to go to the settings page
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Close the drawer
              Navigator.pop(context);

              // Open settings page
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsWidget()));
            },
          ),

          // @todo Show app version here
          // @todo Show feedback link here
        ],
      ),
    );
  }
}
