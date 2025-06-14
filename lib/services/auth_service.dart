import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/profile_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sign Up with Email and Password
  Future<User?> signUpWithEmail(
      String email, String password, String fullName) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (result.user != null) {
        // Update the user's display name
        await result.user!.updateDisplayName(fullName);
        // create /users/{uid} profile doc on first sign-up with full name
        await ProfileService()
            .createIfMissing(result.user!, fullName: fullName);
      }
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Sign-up failed';
    }
  }

  /// Sign In with Email and Password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        // ensure profile doc exists even if the user registered elsewhere
        await ProfileService().createIfMissing(result.user!);
      }

      return result.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Sign-in failed';
    }
  }

  /// Sign In with Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) throw 'Google sign-in canceled';

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);
      if (result.user != null) {
        await ProfileService().createIfMissing(result.user!);
      }
      return result.user;
    } catch (e) {
      throw e.toString();
    }
  }

  /// Send Password Reset Email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Password reset failed';
    }
  }

  /// Sign Out from Firebase and Google
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }

  /// Get Current Logged-in User
  User? getCurrentUser() => _auth.currentUser;
}
