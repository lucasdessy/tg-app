import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sales_platform_app/application/training/training_view_model.dart';
import 'package:sales_platform_app/domain/analytics/analytics_service.dart';
import 'package:sales_platform_app/domain/util/print.dart';

import '../../domain/training/training_service.dart';

part 'training_cubit.freezed.dart';
part 'training_state.dart';

@injectable
class TrainingCubit extends Cubit<TrainingState> with Printable {
  final AnalyticsService _analyticsService;
  final TrainingService _trainingService;
  TrainingCubit(this._analyticsService, this._trainingService)
      : super(const TrainingState());

  Future<void> loadTraining(String categoryId, String? id) async {
    try {
      emit(state.copyWith(isLoading: true, categoryId: categoryId));
      final category = await _trainingService.getCategory(categoryId);
      emit(state.copyWith(categoryName: category.name));
      if (id != null) {
        final training = await _trainingService.getTraining(id);
        String? url;
        try {
          url = (training.videoUrl == null || training.videoUrl!.isEmpty)
              ? null
              : (await _trainingService.getMainVideoUrl(
                  url: training.videoUrl!));
        } catch (e) {
          log('Error getting video url: $e');
        }

        emit(
          state.copyWith(
            training:
                TrainingViewModel(categoryName: category.name, data: training),
            mainVideoUrl: url,
          ),
        );
        _analyticsService.registerTrainingClickedEvent(training.videoName);
      }
      // Get the remaining trainings from same category
      final trainings =
          await _trainingService.getTrainings(categoryId: categoryId);
      // Remove the current training from the list

      if (id != null) {
        trainings.removeWhere((training) => training.id == id);
      }
      final categories = await _trainingService.getCategories();
      trainings.removeWhere((training) => !categories
          .map((category) => category.id)
          .contains(training.category));
      emit(
        state.copyWith(
          trainings: trainings
              .map<TrainingViewModel>(
                (e) => TrainingViewModel(categoryName: category.name, data: e),
              )
              .toList(),
          isLoading: false,
        ),
      );
      _analyticsService.registerTrainingCategoryEvent(category.name);
    } catch (e, stack) {
      log("Error getting training: $e, $stack");
      emit(state.copyWith(failure: e.toString(), isLoading: false));
      _analyticsService.registerError(e, stack);
    }
  }
}
