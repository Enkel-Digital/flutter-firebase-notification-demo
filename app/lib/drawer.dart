import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './data.dart';
import './settings.dart';

/// Drawer widget
class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<DataModel>(
        builder: (context, dataModel, child) {
          // @todo Run this once only every time messages is updated instead of running every single time drawer is opened
          // Fold messages to count how many messages per type
          // Reference: https://stackoverflow.com/a/66492956
          //
          // Then create a list of widgets with the map of "message type to count"
          final messageTypes = dataModel.messages
              .fold(
                  <String, int>{},
                  (Map<String, int> map, msg) => map
                    ..update(msg.type, (count) => count + 1, ifAbsent: () => 1))
              .entries
              // @todo Sort by anything or random?
              .map((entry) => ListTile(
                  leading: const Icon(Icons.arrow_right_alt),
                  title: Text(entry.key),
                  trailing: Text(entry.value.toString()),
                  onTap: () {
                    // Update the state of the app.
                    context.read<DataModel>().filterWith(entry.key);
                    // Then close the drawer
                    Navigator.pop(context);
                  }))
              .toList();

          return Drawer(
            // ListView lets users scroll through options even if there isn't enough vertical space
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,

              children: [
                // @todo Add app logo here
                DrawerHeader(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary),
                    child: const Text('Drawer Header')),

                // Default home page route
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Show all Messages'),
                  onTap: () {
                    // Update the state of the app.
                    context.read<DataModel>().filterWith(null);
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsWidget()));
                  },
                ),

                // @todo Show feedback link here

                const ListTile(
                  leading: Icon(Icons.app_settings_alt),
                  // @todo Show dynamic app version + build time
                  title: Text('Version 0.0.0'),
                ),
              ],
            ),
          );
        },
      );
}
