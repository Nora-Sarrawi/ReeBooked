import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class ProfileService {
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  /// Ensure the /users/{uid} doc exists after first sign-in
  Future<void> createIfMissing(User user) async {
    final doc = _db.collection('users').doc(user.uid);
    if (!(await doc.get()).exists) {
      await doc.set({
        'displayName': user.displayName ?? '',
        'email': user.email,
        'location': '',
        'bio': '',
        'avatarUrl': '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// Realtime stream of the profile data
  Stream<DocumentSnapshot<Map<String, dynamic>>> stream(String uid) =>
      _db.collection('users').doc(uid).snapshots();

  /// Patch update
  Future<void> update(String uid, Map<String, dynamic> data) =>
      _db.collection('users').doc(uid).update(data);

  /// Upload avatar, return its download URL
  Future<String> uploadAvatar(String uid, XFile pick) async {
    final ref = _storage
        .ref('avatars/$uid/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await ref.putFile(File(pick.path));
    return await ref.getDownloadURL();
  }
}
