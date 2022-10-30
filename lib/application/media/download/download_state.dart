part of 'download_cubit.dart';

@freezed
class DownloadState with _$DownloadState {
  const factory DownloadState({
    DownloadType? downloadType,
    bool? doneDownloading,
    @Default(false) bool startedDownloading,
    double? progress,
    String? error,
  }) = _DownloadState;
}
