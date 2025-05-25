import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FcmService {
  final _msg   = FirebaseMessaging.instance;
  final _users = FirebaseFirestore.instance.collection('users');

  Future<void> init() async {
    // iOS permission dialog; Android just returns granted by default.
    await _msg.requestPermission();

    // First token
    final token = await _msg.getToken();
    if (token != null) await _saveToken(token);

    // Any future rotations
    _msg.onTokenRefresh.listen(_saveToken);
  }

  Future<void> _saveToken(String token) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;                   // not signed in yet
    await _users.doc(uid).collection('tokens').doc(token).set({
      'token': token,
      'platform': Platform.operatingSystem,    // "android" | "ios"
      'createdAt': FieldValue.serverTimestamp(),
      'lastSeen':  FieldValue.serverTimestamp(),
    });
  }
}
