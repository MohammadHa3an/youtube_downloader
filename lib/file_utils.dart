import 'dart:io';

//// clean name of the file function
String sanitizeFileName(String name) {
  return name.replaceAll(RegExp(r'[\/\\:*?"<>|]'), '_');
}

//// create a new file function
Future<String> createDownloadDirectory(String folderName) async {
  var directory = Directory(folderName);

  //// if directory does not exist, create it
  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }

  return directory.path;
}

//// check existence of files
Future<bool> fileExists(String filePath) async {
  var file = File(filePath);
  return await file.exists();
}
