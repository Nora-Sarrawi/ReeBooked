import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';          // ← NEW
import 'package:rebooked_app/services/fcm_service.dart';
import 'firebase_options.dart';
import 'app.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ── NEW: wait for the user to be signed-in and then save / refresh token ──
  await FirebaseAuth.instance.authStateChanges().first;     // waits for a User?
  await FcmService().init();

  runApp(const ReBooked());
}