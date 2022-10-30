import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sales_platform_app/domain/analytics/analytics_service.dart';
import 'package:sales_platform_app/domain/failure.dart';
import 'package:sales_platform_app/domain/media/media_service.dart';
import 'package:sales_platform_app/domain/util/print.dart';

import '../../domain/media/media_model.dart';

part 'media_cubit.freezed.dart';
part 'media_state.dart';

@injectable
class MediaCubit extends Cubit<MediaState> with Printable {
  final AnalyticsService _analyticsService;
  final MediaService _mediaService;
  MediaCubit(this._analyticsService, this._mediaService)
      : super(const MediaState());

  Future<void> loadMedia(String id) async {
    try {
      emit(state.copyWith(isLoading: true));
      final media = await _mediaService.getMedia(id);
      final medias = await _mediaService.getMediaList(id);
      try {
        final videoUrl =
            await _mediaService.getMainVideoUrl(url: media.videoUrl);
        log("video url: $videoUrl");
        emit(state.copyWith(
          mainVideoUrl: videoUrl,
        ));
        _analyticsService.registerMediaClickedEvent(media.videoName);
      } on AppFailure catch (e, stack) {
        log('Error getting main video url: $e');
        emit(state.copyWith(
          mainVideoUrl: "error",
        ));
        _analyticsService.registerError(e, stack);
      } catch (e, stack) {
        log('Error getting main video url: $e');
        emit(state.copyWith(
          mainVideoUrl: "error",
        ));
        _analyticsService.registerError(e, stack);
      }

      emit(
        state.copyWith(
          media: media,
          isLoading: false,
          medias: medias,
        ),
      );
    } catch (e, stack) {
      emit(state.copyWith(failure: e.toString(), isLoading: false));
      _analyticsService.registerError(e, stack);
    }
  }
}
