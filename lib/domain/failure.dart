import 'package:sales_platform_app/domain/util/format_firebase_errors.dart';

class AppFailure implements Exception {
  final String message;
  AppFailure(this.message);
  factory AppFailure.unknown() => AppFailure('Ocorreu um erro desconhecido.');
  @override
  String toString() {
    return "AppFailure: $message";
  }
}

class FirebaseFailure extends AppFailure {
  FirebaseFailure(String code) : super(formatFirebaseErrors(code));
  @override
  String toString() {
    return 'FirebaseFailure{code: $message}';
  }
}
