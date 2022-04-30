import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './data.dart';
import './settings.dart';

/// Drawer widget
class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<DataModel>(
        builder: (context, dataModel, child) => Drawer(
          // ListView lets users scroll through options even if there isn't enough vertical space
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,

            children: [
              // Spacing to ensure DrawerHeader's image not partially covered by OS top bar
              const SizedBox(height: 14),

              const DrawerHeader(
                child: SizedBox.shrink(),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/logo.png'),
                        fit: BoxFit.contain)),
              ),

              // Default home page route
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Show all Messages'),
                trailing: Text(dataModel.messages.length.toString()),
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

              // @todo Current order is random, sort by anything?
              // Programmatically generated message type widgets
              for (final entry in dataModel.messageTypes.entries)
                ListTile(
                    leading: const Icon(Icons.arrow_right_alt),
                    title: Text(entry.key),
                    trailing: Text(entry.value.toString()),
                    onTap: () {
                      // Update the state of the app.
                      context.read<DataModel>().filterWith(entry.key);
                      // Then close the drawer
                      Navigator.pop(context);
                    }),

              /* Alternative: Generate the list before this drawer widget */
              // Create a list of widgets with the map of "message type to count"
              // final messageTypes = dataModel.messageTypes.entries
              //     .map((entry) => ListTile(
              //         leading: const Icon(Icons.arrow_right_alt),
              //         title: Text(entry.key),
              //         trailing: Text(entry.value.toString()),
              //         onTap: () {
              //           // Update the state of the app.
              //           context.read<DataModel>().filterWith(entry.key);
              //           // Then close the drawer
              //           Navigator.pop(context);
              //         }))
              //     .toList();
              // // Leave this in this array
              // ...messageTypes,

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

              ListTile(
                leading: const Icon(Icons.timelapse),
                title: Text('Last Sync:\n${dataModel.lastSyncTimeString}'),
              ),

              Link(
                target: LinkTarget.self,
                uri: Uri.parse("https://www.google.com"), // @todo
                builder: (context, followLink) => ListTile(
                  leading: const Icon(Icons.feedback),
                  title: const Text('Feedback Form'),
                  onTap: () {
                    // Close the drawer
                    Navigator.pop(context);

                    // Open link with in app webview
                    // Null check added as the type suggests `followLink` might be null
                    if (followLink != null) followLink();
                  },
                ),
              ),

              const ListTile(
                leading: Icon(Icons.app_settings_alt),
                // @todo Show dynamic app version + build time
                title: Text('Version 0.0.0'),
              ),
            ],
          ),
        ),
      );
}
