import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_platform_app/domain/util/datetime_converter.dart';

part 'training_model.freezed.dart';
part 'training_model.g.dart';

@freezed
class TrainingModel with _$TrainingModel {
  const factory TrainingModel({
    String? id,
    required String category,
    @TimestampConverter() required DateTime createdAt,
    required String thumb,
    required String videoName,
    required String? videoUrl,
    bool? enabled,
  }) = _TrainingModel;

  factory TrainingModel.fromJson(String id, Map<String, dynamic> json) =>
      _$TrainingModelFromJson(json).copyWith(id: id);
}
