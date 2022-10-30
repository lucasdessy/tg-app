part of 'trainings_cubit.dart';

@freezed
class TrainingsState with _$TrainingsState {
  const factory TrainingsState({
    @Default(false) bool isLoading,
    @Default(<String, List<TrainingViewModel>>{})
        Map<String, List<TrainingViewModel>>? trainings,
    TrainingViewModel? latestTraining,
    @Default(null) String? failure,
  }) = _TrainingsState;
}
