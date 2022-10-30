import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_platform_app/domain/util/datetime_converter.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    String? id,
    String? aboutMe,
    @TimestampConverter() DateTime? birthDate,
    String? cep,
    String? city,
    String? complement,
    required String cpf,
    required String fullName,
    String? name,
    String? neighborhood,
    String? number,
    String? phone,
    String? profession,
    String? profilePicture,
    String? state,
    String? street,
  }) = _UserModel;

  factory UserModel.fromJson(String id, Map<String, dynamic> json) =>
      _$UserModelFromJson(json).copyWith(id: id);
}
