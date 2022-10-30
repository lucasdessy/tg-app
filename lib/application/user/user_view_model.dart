import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_platform_app/application/user/address_view_model.dart';
import 'package:sales_platform_app/application/user/personal_info_view_model.dart';

import '../../domain/user/user_model.dart';

part 'user_view_model.freezed.dart';

@freezed
class UserViewModel with _$UserViewModel {
  const factory UserViewModel({
    String? name,
    String? profileImageUrl,
    required AddressViewModel address,
    required PersonalInfoViewModel personalInfo,
  }) = _UserViewModel;

  factory UserViewModel.fromDomain(UserModel user, {required String? email}) =>
      UserViewModel(
        name: user.name,
        profileImageUrl: user.profilePicture,
        address: AddressViewModel.fromDomain(user),
        personalInfo: PersonalInfoViewModel.fromDomain(user, email: email),
      );
}
