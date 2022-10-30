import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthService {
  Future<User?> signInWithEmailAndPassword(String email, String password);
  User? get currentUser;
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> resetPassword(
      {required String currentPassword,
      required String newPassword,
      required String confirmPassword});
}
