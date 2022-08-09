import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> _localFile(
    String fileName,
  ) async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  Future<String> readFile({
    required String fileName,
  }) async {
    try {
      final file = await _localFile(fileName);
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      return '';
    }
  }

  Future<File> writeFile({
    required String fileName,
    required String value,
  }) async {
    final file = await _localFile(fileName);
    return file.writeAsString(value);
  }
}
