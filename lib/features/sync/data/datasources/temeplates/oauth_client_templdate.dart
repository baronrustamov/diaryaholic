import 'dart:io';

abstract class IOAuthClient {
  Future<bool> initialieClient();

  Future<void> signIn();

  Future<bool> isFilePresent(String fileName, {bool folder = false});

  Future<bool> createFolder(String folderName, {String? parentFolder});

  Future<bool> deleteFile(String fileName, {bool folder = false});

  /// File content can be a Flutter File object, or file content, name and extension can be passed separately
  Future<bool> uploadFile({
    String? fileContent,
    String? fileName,
    File? file,
    required String parentFolder,
  });

  /// if [outputAsFile] is true, saves the received media in a file and returns the file's location in Right of Either
  /// else returns the content as String in Left of Either
  Future<String> downloadFile(String fileName, {bool outputAsFile = false});

  Future<bool> updateFile(
      {required String fileName, required String fileContent});

  Future<void> signOut();

  Future<bool> isSignedIn();

  Future<String?> getSignedInUserInfo();

  Future<void> updateLastSynced();

  Future<DateTime?> getNoteCreatedTime(String fileName);
}
