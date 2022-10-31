import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sales_platform_app/domain/analytics/analytics_service.dart';
import 'package:sales_platform_app/domain/download/download_service.dart';
import 'package:sales_platform_app/domain/failure.dart';
import 'package:sales_platform_app/domain/util/print.dart';

import '../../../domain/download/download_type.dart';

part 'download_cubit.freezed.dart';
part 'download_state.dart';

@injectable
class DownloadCubit extends Cubit<DownloadState> with Printable {
  final AnalyticsService _analyticsService;
  final DownloadService _downloadService;
  DownloadCubit(this._analyticsService, this._downloadService)
      : super(DownloadState.initial());

  void clean() {
    emit(const DownloadState());
  }

  Future<void> download(String id) async {
    log('Downloading media...');
    final downloadType = state.downloadType!;
    emit(state.copyWith(startedDownloading: true));
    try {
      log('Entering download loop');
      await for (var serviceState
          in _downloadService.download(id, downloadType)) {
        emit(
          state.copyWith(
            progress: serviceState.progress,
            doneDownloading: serviceState.doneDownloading,
          ),
        );
      }
      log('Download complete.');
      _analyticsService.registerDownloadedMediaEvent(downloadType);
    } catch (e, stack) {
      log("Errito no cubito: $e");
      if (e is AppFailure) {
        emit(state.copyWith(error: e.message, startedDownloading: false));
        _analyticsService.registerError(e, stack);
      } else {
        emit(state.copyWith(
            error: AppFailure.unknown().message, startedDownloading: false));
        _analyticsService.registerError(e, stack);
      }
    }
  }
}
