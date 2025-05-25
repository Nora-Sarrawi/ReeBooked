import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads [file] to Storage at [path] (e.g. "avatars/uid.jpg")
  /// Returns the public download URL.
  Future<String> uploadFile(File file, String path) async {
    final ref = _storage.ref(path);
    await ref.putFile(file);                        // upload bytes
    return await ref.getDownloadURL();              // get URL
  }
}
