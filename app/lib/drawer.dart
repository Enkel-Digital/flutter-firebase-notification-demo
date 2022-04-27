import 'package:flutter/material.dart';

import './settings.dart';

/// Drawer widget
class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

          // @todo Programmatically generate this based on all the message types with indexes
          ListTile(
            title: const Text('Message type 1'),
            onTap: () {
              // Update the state of the app.
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),

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
