import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sales_platform_app/application/training/training_view_model.dart';
import 'package:sales_platform_app/domain/analytics/analytics_service.dart';
import 'package:sales_platform_app/domain/util/print.dart';

import '../../domain/failure.dart';
import '../../domain/training/category_model.dart';
import '../../domain/training/training_service.dart';

part 'trainings_cubit.freezed.dart';
part 'trainings_state.dart';

@injectable
class TrainingsCubit extends Cubit<TrainingsState> with Printable {
  final AnalyticsService _analyticsService;
  final TrainingService _trainingService;
  TrainingsCubit(this._analyticsService, this._trainingService)
      : super(const TrainingsState());

  Future<TrainingViewModel> _getLatestTrainings() async {
    try {
      log("Getting latest training");
      final latestTraining = await _trainingService.getLatestTraining();
      return TrainingViewModel(
        data: latestTraining,
        categoryName: CategoryModel.unknown().name,
      );
    } catch (e) {
      log("Error getting latest training: $e");
      throw AppFailure("Ocorreu um erro ao buscar o treinamento");
    }
  }

  Future<void> getTrainings() async {
    log('getTrainings...');
    emit(const TrainingsState());
    try {
      emit(state.copyWith(isLoading: true));
      final categories = await _trainingService.getCategories();
      final trainings = await _trainingService.getTrainings();
      log('got ${trainings.length} trainings and ${categories.length} categories');
      final Map<String, List<TrainingViewModel>> trainingsByCategory = {};

      // Make first category "Latest". Limit to 10 trainings
      final latestCat = CategoryModel.latest();
      trainingsByCategory[latestCat.id!] = trainings
          .where((element) {
            final containsCat =
                categories.map((e) => e.id).contains(element.category);
            if (!containsCat) {
              log('Removing training ${element.id} because it has no category');
            }
            return containsCat;
          })
          .map((e) => TrainingViewModel(
                data: e.copyWith(category: latestCat.id!),
                categoryName: latestCat.name,
              ))
          .toList();
      log('got ${trainingsByCategory[latestCat.id!]!.length} latest trainings');
      for (final training in trainings) {
        for (final category in categories) {
          if (training.category == category.id) {
            final key =
                (category.order ?? double.maxFinite).toString() + category.id!;
            trainingsByCategory.putIfAbsent(key, () => []);
            trainingsByCategory[key]!.add(TrainingViewModel(
              categoryName: category.name,
              data: training,
            ));
          }
        }
      }

      // log("Ordering keys by time");
      // for (final key in trainingsByCategory.keys) {
      //   trainingsByCategory[key]!.sort(
      //     (b, a) => a.data.createdAt.compareTo(
      //       b.data.createdAt,
      //     ),
      //   );
      // }
      final sortedMap = Map.fromEntries(
        trainingsByCategory.entries.toList()
          ..sort((e2, e1) => e1.key.compareTo(e2.key)),
      );
      log(sortedMap.keys);
      final latestTraining = await _getLatestTrainings();
      emit(state.copyWith(
        trainings: sortedMap,
        latestTraining: latestTraining,
        isLoading: false,
      ));
    } catch (e, stack) {
      emit(state.copyWith(failure: e.toString(), isLoading: false));
      log("Error getting trainings: $e\n stack: $stack");
      _analyticsService.registerError(e, stack);
    }
  }
}
