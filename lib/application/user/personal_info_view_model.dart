import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/user/user_model.dart';

part 'personal_info_view_model.freezed.dart';

@freezed
class PersonalInfoViewModel with _$PersonalInfoViewModel {
  const factory PersonalInfoViewModel({
    String? email,
    String? fullname,
    String? cpf,
    String? profession,
    DateTime? birthDate,
    String? phone,
    String? state,
    String? aboutMe,
  }) = _PersonalInfoViewModel;
  factory PersonalInfoViewModel.fromDomain(UserModel user,
          {required String? email}) =>
      PersonalInfoViewModel(
        fullname: user.fullName,
        cpf: user.cpf,
        profession: user.profession,
        birthDate: user.birthDate,
        phone: user.phone,
        state: user.state,
        aboutMe: user.aboutMe,
        email: email,
      );
}
