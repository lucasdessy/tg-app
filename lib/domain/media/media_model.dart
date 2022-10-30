import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_model.freezed.dart';
part 'media_model.g.dart';

@freezed
class MediaModel with _$MediaModel {
  const factory MediaModel({
    String? id,
    required String description,
    required String feedLink,
    required String horizontalLink,
    required String storyLink,
    required String thumb,
    required String videoName,
    required String videoUrl,
    int? order,
    bool? enabled,
    String? blurHash,
  }) = _MediaModel;

  factory MediaModel.fromJson(String id, Map<String, dynamic> json) =>
      _$MediaModelFromJson(json).copyWith(id: id);
}
