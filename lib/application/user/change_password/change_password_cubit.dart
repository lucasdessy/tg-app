import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sales_platform_app/domain/analytics/analytics_service.dart';
import 'package:sales_platform_app/domain/auth/auth_service.dart';
import 'package:sales_platform_app/domain/failure.dart';
import 'package:sales_platform_app/domain/util/print.dart';

part 'change_password_cubit.freezed.dart';
part 'change_password_state.dart';

@injectable
class ChangePasswordCubit extends Cubit<ChangePasswordState> with Printable {
  final AnalyticsService _analyticsService;
  final AuthService _authService;
  ChangePasswordCubit(this._analyticsService, this._authService)
      : super(const ChangePasswordState());

  void clear() {
    emit(const ChangePasswordState());
  }

  void onCurrentPasswordChanged(String value) {
    emit(state.copyWith(currentPassword: value));
  }

  void onNewPasswordChanged(String value) {
    emit(state.copyWith(newPassword: value));
  }

  void onConfirmPasswordChanged(String value) {
    emit(state.copyWith(confirmPassword: value));
  }

  Future<void> submit() async {
    try {
      emit(state.copyWith(loading: true));
      await _authService.resetPassword(
        currentPassword: state.currentPassword,
        newPassword: state.newPassword,
        confirmPassword: state.confirmPassword,
      );
      emit(state.copyWith(loading: false, isDone: true));
      _analyticsService.registerChangePasswordEvent();
    } on AppFailure catch (e, stack) {
      emit(state.copyWith(error: e.message));
      _analyticsService.registerError(e, stack);
    } catch (err, stack) {
      log(err);
      emit(state.copyWith(error: AppFailure.unknown().message));
      _analyticsService.registerError(err, stack);
    }
  }
}
