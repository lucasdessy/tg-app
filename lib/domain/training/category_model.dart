import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    String? id,
    int? order,
    bool? enabled,
    required String name,
  }) = _MediaModel;

  factory CategoryModel.unknown() => const CategoryModel(
        id: "",
        name: 'Desconhecido',
      );

  factory CategoryModel.latest() => const CategoryModel(
        id: "latest",
        name: 'Últimas Postagens',
      );

  factory CategoryModel.fromJson(String id, Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json).copyWith(id: id);
}
