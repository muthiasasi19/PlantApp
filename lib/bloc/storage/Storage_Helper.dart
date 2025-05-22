import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class StorageHelper {
  static Future<String> _getFolderPath() async {
    final Directory? dir = await getExternalStorageDirectory();
    final folder = Directory('${dir!.path}/FlutterNative');
    if (!await folder.exists()) await folder.create(recursive: true);
    return folder.path;
  }

  static Future<File> saveImage(File file, String prefix) async {
    final String dirPath = await _getFolderPath();
    final String fileName =
        '$prefix${DateTime.now().millisecondsSinceEpoch}${path.extension(file.path)}';
    final String savedPath = path.join(dirPath, fileName);
    return await file.copy(savedPath);
  }
}
