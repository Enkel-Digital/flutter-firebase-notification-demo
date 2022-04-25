import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Storage {
  static const dataFile = "data.json";

  static Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$dataFile');
  }

  // @todo include json parser
  static Future<String> read() async {
    try {
      final file = await _localFile;

      if (await file.exists()) {
        return file.readAsString();
      } else {
        // Create a default data file and return it
        return "empty-data-file";
      }
    } catch (e) {
      // @todo handle this error
      // ignore: avoid_print
      print("Storage.read: read file failed, $e");
      return "";
    }
  }

  static Future<File> write(String data) async {
    final file = await _localFile;
    return file.writeAsString(data);
  }
}
