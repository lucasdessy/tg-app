import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sales_platform_app/domain/analytics/analytics_service.dart';

import '../../domain/auth/auth_service.dart';
import '../../domain/util/print.dart';

part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

@singleton
class AuthCubit extends Cubit<AuthState> with Printable {
  final AnalyticsService _analyticsService;
  final AuthService _authService;

  AuthCubit(this._analyticsService, this._authService)
      : super(const AuthState.initial());

  void authCheck() async {
    log("checking auth");
    final user = _authService.currentUser;
    if (user != null) {
      emit(AuthState.authenticated(user));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  void signOut() async {
    log("signing out");
    await _authService.signOut();
    emit(const AuthState.unauthenticated());
    _analyticsService.registerLogoutEvent();
  }
}
