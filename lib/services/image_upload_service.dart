import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageUploadService {
  static Future<XFile?> pickAndCompressImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return null;

    final tempDir = await getTemporaryDirectory();
    final targetPath = path.join(tempDir.path, 'compressed_${path.basename(pickedFile.path)}');

    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      pickedFile.path,
      targetPath,
      quality: 70,
    );

    return compressedFile;
  }

  static Future<String> uploadImage(File file) async {
    final fileName = path.basename(file.path);
    final ref = FirebaseStorage.instance.ref().child('book_covers/$fileName');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  static Future<void> createBookDoc({
    required String author,
    required String imageUrl,
    required String genre,
    required DateTime dueDate,
    required String location,
  }) async {
    await FirebaseFirestore.instance.collection('books').add({
      'author': author,
      'coverUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
      'description': '',
      'dueDate': Timestamp.fromDate(dueDate),
      'genre': genre,
      'loanedTo': '',
      'location': location,
    });
  }

  static Future<void> handleUpload({
    required String author,
    required String genre,
    required DateTime dueDate,
    required String location,
  }) async {
    final image = await pickAndCompressImage();
    if (image == null) return;

    final imageUrl = await uploadImage(image as File);
    await createBookDoc(
      author: author,
      imageUrl: imageUrl,
      genre: genre,
      dueDate: dueDate,
      location: location,
    );
  }
}
