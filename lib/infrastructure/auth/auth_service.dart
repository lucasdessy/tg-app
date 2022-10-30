import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:sales_platform_app/domain/failure.dart';
import 'package:sales_platform_app/domain/util/print.dart';

import '../../domain/auth/auth_service.dart';

@Singleton(as: AuthService)
class AuthServiceImpl with Printable implements AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (err) {
      log(err);
      throw FirebaseFailure(err.code);
    } catch (err) {
      throw AppFailure.unknown();
    }
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (err) {
      log(err);
      log(err.code);
      throw FirebaseFailure(err.code);
    } catch (err) {
      throw AppFailure.unknown();
    }
  }

  @override
  Future<void> resetPassword(
      {required String currentPassword,
      required String newPassword,
      required String confirmPassword}) async {
    try {
      if (newPassword != confirmPassword) {
        throw AppFailure("As senhas não conferem");
      }
      final credentials = EmailAuthProvider.credential(
          email: currentUser!.email!, password: currentPassword);
      log("Reauthenticating with credentials: $credentials");
      await _firebaseAuth.currentUser!
          .reauthenticateWithCredential(credentials);
      log("Reauthentication successful. Updating password.");
      await _firebaseAuth.currentUser!.updatePassword(newPassword);
    } on FirebaseAuthException catch (err) {
      log(err);
      log(err.code);
      throw FirebaseFailure(err.code);
    } catch (err) {
      throw AppFailure.unknown();
    }
  }
}
