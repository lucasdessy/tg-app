part of 'medias_cubit.dart';

@freezed
class MediasState with _$MediasState {
  factory MediasState({
    @Default(false) bool isLoading,
    @Default(<MediaModel>[]) List<MediaModel> medias,
    @Default(null) String? failure,
    String? mediaHeaderUrl,
  }) = _MediaState;
}
