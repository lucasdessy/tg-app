import 'package:freezed_annotation/freezed_annotation.dart';

part 'download_state.freezed.dart';

@freezed
class DownloadState with _$DownloadState {
  const factory DownloadState({
    @Default(0) double progress,
    @Default(false) bool doneDownloading,
  }) = _DownloadState;
}
