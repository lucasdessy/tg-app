part of 'change_password_cubit.dart';

@freezed
class ChangePasswordState with _$ChangePasswordState {
  const factory ChangePasswordState({
    @Default("") String currentPassword,
    @Default("") String newPassword,
    @Default("") String confirmPassword,
    String? error,
    @Default(false) bool loading,
    @Default(false) bool isDone,
  }) = _ChangePasswordState;
}
