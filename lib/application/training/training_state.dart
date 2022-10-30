part of 'training_cubit.dart';

@freezed
class TrainingState with _$TrainingState {
  const factory TrainingState({
    @Default(false) bool isLoading,
    TrainingViewModel? training,
    @Default(<TrainingViewModel>[]) List<TrainingViewModel> trainings,
    String? categoryName,
    String? failure,
    String? mainVideoUrl,
    @Default("") String categoryId,
  }) = _TrainingState;
}
