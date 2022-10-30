part of 'user_cubit.dart';

@freezed
class UserState with _$UserState {
  const factory UserState({
    @Default(false) bool loading,
    String? error,
    UserViewModel? user,
    String? telegramLink,
    String? helpLink,
  }) = _UserState;
}
