import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sales_platform_app/domain/analytics/analytics_service.dart';
import 'package:sales_platform_app/domain/global/global_service.dart';
import 'package:sales_platform_app/domain/media/media_model.dart';
import 'package:sales_platform_app/domain/media/media_service.dart';
import 'package:sales_platform_app/domain/util/print.dart';

part 'medias_cubit.freezed.dart';
part 'medias_state.dart';

@injectable
class MediasCubit extends Cubit<MediasState> with Printable {
  final AnalyticsService _analyticsService;
  final MediaService _mediaService;
  final GlobalService _globalService;
  MediasCubit(this._analyticsService, this._mediaService, this._globalService)
      : super(MediasState());

  Future<void> getMedias() async {
    try {
      log("Getting medias...");
      emit(state.copyWith(isLoading: true));
      final medias = await _mediaService.getMediaList();
      emit(state.copyWith(medias: medias, isLoading: false));
      // Get media header url
      final mediaHeaderUrl = await _globalService.getMediaHeaderUrl();
      log("Media header url: $mediaHeaderUrl");
      emit(state.copyWith(mediaHeaderUrl: mediaHeaderUrl));
    } catch (e, stack) {
      emit(state.copyWith(failure: e.toString(), isLoading: false));
      _analyticsService.registerError(e, stack);
    }
  }
}
