import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sales_platform_app/domain/analytics/analytics_service.dart';
import 'package:sales_platform_app/domain/auth/auth_service.dart';
import 'package:sales_platform_app/domain/failure.dart';
import 'package:sales_platform_app/domain/util/print.dart';

part 'reset_password_cubit.freezed.dart';
part 'reset_password_state.dart';

@injectable
class ResetPasswordCubit extends Cubit<ResetPasswordState> with Printable {
  final AnalyticsService _analyticsService;
  final AuthService _authService;
  ResetPasswordCubit(this._analyticsService, this._authService)
      : super(const ResetPasswordState());

  void onEmailChanged(String email) {
    emit(state.copyWith(email: email));
  }

  Future<void> onResetPassword() async {
    emit(state.copyWith(isLoading: true));
    try {
      await _authService.sendPasswordResetEmail(state.email);
      emit(state.copyWith(isLoading: false, isSuccess: true));
      await _analyticsService.registerResetPasswordEvent();
    } on AppFailure catch (err, stack) {
      emit(state.copyWith(
          isLoading: false, isSuccess: false, failure: err.message));
      _analyticsService.registerError(err, stack);
    } catch (err, stack) {
      emit(state.copyWith(
          isLoading: false,
          isSuccess: false,
          failure: AppFailure.unknown().message));
      _analyticsService.registerError(err, stack);
    }
  }

  void cleanState() {
    emit(const ResetPasswordState());
  }
}
