import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/user/user_model.dart';

part 'address_view_model.freezed.dart';

@freezed
class AddressViewModel with _$AddressViewModel {
  const factory AddressViewModel({
    String? cep,
    String? street,
    String? number,
    String? complement,
    String? neighborhood,
    String? state,
    String? city,
  }) = _AddressViewModel;

  factory AddressViewModel.fromDomain(UserModel user) => AddressViewModel(
        cep: user.cep,
        street: user.street,
        number: user.number,
        complement: user.complement,
        neighborhood: user.neighborhood,
        state: user.state,
        city: user.city,
      );
}
