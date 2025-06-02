import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class ProfileService {
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  /// Ensure the /users/{uid} doc exists after first sign-in
  Future<void> createIfMissing(User user, {String? fullName}) async {
    final doc = _db.collection('users').doc(user.uid);
    if (!(await doc.get()).exists) {
      await doc.set({
        'displayName': fullName ?? user.displayName ?? '',
        'email': user.email,
        'location': '',
        'bio': '',
        'avatarUrl': user.photoURL ??
            'https://i.pinimg.com/736x/3c/ae/07/3cae079ca0b9e55ec6bfc1b358c9b1e2.jpg',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// Upload avatar and return the download URL
  Future<String> uploadAvatar(String uid, XFile pick) async {
    final ref = _storage
        .ref('avatars/$uid/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await ref.putFile(File(pick.path));
    return await ref.getDownloadURL();
  }

  /// Realtime stream of the profile data
  Stream<DocumentSnapshot<Map<String, dynamic>>> stream(String uid) =>
      _db.collection('users').doc(uid).snapshots();

  /// Patch update
  Future<void> update(String uid, Map<String, dynamic> data) =>
      _db.collection('users').doc(uid).update(data);

  /// Get owner profile data
  Future<Map<String, dynamic>?> getOwnerProfile(String ownerId) async {
    try {
      final doc = await _db.collection('users').doc(ownerId).get();
      if (!doc.exists) return null;

      final data = doc.data()!;
      return {
        'ownerName': data['displayName'] ?? 'Unknown',
        'ownerAvatar': data['avatarUrl'],
      };
    } catch (e) {
      print('Error fetching owner profile: $e');
      return null;
    }
  }
}
