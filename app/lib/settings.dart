import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

// import './data.dart';

class Settings {
  // int? lastSync;
}

class SettingsWidget extends StatelessWidget {
  final Settings settings = Settings();
  SettingsWidget({Key? key}) : super(key: key);

  // final Settings settings;
  // const SettingsWidget({Key? key, required this.settings}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: Center(
          child: Column(
            children: [
              // @todo Add: Version number + date + build time
              // @todo Add: Show last sync time
              // @todo Add: Check for update and ask user to update if outdated

              // Button to open feedback form
              Link(
                target: LinkTarget.self,
                uri: Uri.parse("https://www.google.com"), // @todo
                builder: (context, followLink) => ElevatedButton(
                  onPressed: followLink,
                  child: const Text("Feedback Form"),
                ),
              )
            ],
          ),
        ),
      );
}
