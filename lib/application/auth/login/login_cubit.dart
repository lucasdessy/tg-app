import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sales_platform_app/domain/analytics/analytics_service.dart';
import 'package:sales_platform_app/domain/auth/auth_service.dart';
import 'package:sales_platform_app/domain/util/print.dart';

import '../../../domain/failure.dart';

part 'login_cubit.freezed.dart';
part 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> with Printable {
  final AnalyticsService _analyticsService;
  final AuthService _authService;
  LoginCubit(this._analyticsService, this._authService)
      : super(const LoginState());

  void clean() => emit(const LoginState());

  void onEmailChanged(String email) {
    emit(state.copyWith(email: email));
  }

  void onPasswordChanged(String password) {
    emit(state.copyWith(password: password));
  }

  void onLoginPressed() async {
    emit(state.copyWith(isSubmitting: true));
    try {
      await _authService.signInWithEmailAndPassword(
        state.email,
        state.password,
      );
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
      _analyticsService.registerLoginEvent();
    } on AppFailure catch (err, stack) {
      emit(state.copyWith(
          isSubmitting: false, isSuccess: false, failure: err.message));
      _analyticsService.registerError(err, stack);
    } catch (err, stack) {
      emit(state.copyWith(
          isSubmitting: false,
          isSuccess: false,
          failure: AppFailure.unknown().message));
      _analyticsService.registerError(err, stack);
    }
  }
}
