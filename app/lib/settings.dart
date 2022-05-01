import 'package:flutter/material.dart';

import './utils/placeholder.dart';

// import './data.dart';

class Settings {
  //
}

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  // final Settings settings = Settings();
  // final Settings settings;
  // const SettingsWidget({Key? key, required this.settings}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: Center(
          child: Column(
            children: const [
              Expanded(child: CustomPlaceholder()),

              // @todo Add: Check for update and ask user to update if outdated
            ],
          ),
        ),
      );
}
