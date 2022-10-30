import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_platform_app/domain/training/training_model.dart';

part 'training_view_model.freezed.dart';

@freezed
class TrainingViewModel with _$TrainingViewModel {
  const factory TrainingViewModel({
    required String categoryName,
    required TrainingModel data,
  }) = _TrainingViewModel;
}
