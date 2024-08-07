import 'dart:developer' as developer;
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class PathProvider {
  static const String androidDownloadPath = '/storage/emulated/0/Download';
  Future<String?> downloadPath() async {
    try {
      if (Platform.isIOS) {
        return (await getApplicationDocumentsDirectory()).path;
      }

      return isPathValid(androidDownloadPath)
          ? androidDownloadPath
          : (await getExternalStorageDirectory())?.path;
    } catch (e) {
      developer.log('Cannot get download folder path: $e');
      return null;
    }
  }

  bool isPathValid(String path) {
    final dir = Directory(path);
    return dir.existsSync();
  }
}
