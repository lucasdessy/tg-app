part of 'profile_medias_cubit.dart';

@freezed
class ProfileMediasState with _$ProfileMediasState {
  const factory ProfileMediasState({
    @Default([]) List<PictureViewModel> pictures,
    @Default(false) bool isLoading,
    @Default(false) bool isEditMode,
    @Default([]) List<String> selectedPictures,
    String? error,
    @Default(false) bool isDownloadingSuccess,
  }) = _ProfileMediasState;
}
