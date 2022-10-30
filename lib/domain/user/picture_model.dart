import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_platform_app/domain/util/datetime_converter.dart';

part 'picture_model.freezed.dart';
part 'picture_model.g.dart';

@freezed
class PictureModel with _$PictureModel {
  const factory PictureModel({
    String? id,
    required String url,
    @TimestampConverter() required DateTime createdAt,
  }) = _PictureModel;

  factory PictureModel.fromJson(String id, Map<String, dynamic> json) =>
      _$PictureModelFromJson(json).copyWith(id: id);
}
