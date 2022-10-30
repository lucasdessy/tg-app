part of 'edit_profile_cubit.dart';

@freezed
class EditProfileState with _$EditProfileState {
  const factory EditProfileState.loading() = _Loading;
  const factory EditProfileState.loaded({
    @Default(UserViewModel(
      address: AddressViewModel(),
      personalInfo: PersonalInfoViewModel(),
    ))
        UserViewModel user,
    EditProfileState? previousState,
    @Default(false)
        bool needsToClear,
    @Default(false)
        bool success,
  }) = _Loaded;
  const factory EditProfileState.error(String error) = _Error;
}
