part of 'login_cubit.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    @Default("") String email,
    @Default("") String password,
    @Default(false) bool isSubmitting,
    @Default(false) bool isSuccess,
    @Default(null) String? failure,
  }) = _LoginState;
}
