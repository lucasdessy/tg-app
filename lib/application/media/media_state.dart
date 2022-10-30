part of 'media_cubit.dart';

@freezed
class MediaState with _$MediaState {
  const factory MediaState({
    @Default(false) bool isLoading,
    MediaModel? media,
    @Default(<MediaModel>[]) List<MediaModel> medias,
    String? failure,
    String? mainVideoUrl,
  }) = _MediaState;
}
