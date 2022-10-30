import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:sales_platform_app/application/user/user_view_model.dart';
import 'package:sales_platform_app/domain/analytics/analytics_service.dart';
import 'package:sales_platform_app/domain/auth/auth_service.dart';
import 'package:sales_platform_app/domain/failure.dart';
import 'package:sales_platform_app/domain/image/image_service.dart';
import 'package:sales_platform_app/domain/user/user_model.dart';
import 'package:sales_platform_app/domain/user/user_service.dart';
import 'package:sales_platform_app/domain/util/print.dart';

import '../address_view_model.dart';
import '../personal_info_view_model.dart';

part 'edit_profile_cubit.freezed.dart';
part 'edit_profile_state.dart';

@injectable
class EditProfileCubit extends Cubit<EditProfileState> with Printable {
  final AnalyticsService _analyticsService;
  final UserService _userService;
  final AuthService _authService;
  final ImageService _imageService;
  EditProfileCubit(this._analyticsService, this._userService, this._authService,
      this._imageService)
      : super(const EditProfileState.loading());

  void clearSuccess() {
    state.maybeMap(
      loaded: (state) => emit(state.copyWith(success: false)),
      orElse: () => emit(state),
    );
  }

  Future<void> onNameChanged(String name) async {
    save(newName: name);
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final imageUrl = await _imageService.pickImage(source);
      log('imageUrl: $imageUrl');
      if (imageUrl == null) {
        return;
      }
      final croppedImage = await _imageService.cropImage(imagePath: imageUrl);
      if (croppedImage == null) {
        return;
      }

      log('croppedImage: $croppedImage');

      save(newProfilePicPath: croppedImage);
    } catch (err) {
      log(err);
      emit(EditProfileState.error(AppFailure.unknown().message));
    }
  }

  Future<void> loadProfile() async {
    emit(const EditProfileState.loading());
    log('loadProfile... ${_authService.currentUser!.email}');
    final user = await _userService.getUser(_authService.currentUser!.uid);
    emit(EditProfileState.loaded(
      user: UserViewModel.fromDomain(user,
          email: _authService.currentUser!.email),
      needsToClear: true,
    ));
  }

  void onClearControllers() {
    emit(
      state.maybeMap(
        orElse: () => state,
        loaded: (value) => value.copyWith(needsToClear: false),
      ),
    );
  }

  void onPersonalInfoChanged(PersonalInfoViewModel personalInfo) {
    emit(state.maybeMap(
      orElse: () => state,
      loaded: (value) => value.copyWith(
        user: value.user.copyWith(
          personalInfo: personalInfo,
        ),
      ),
    ));
  }

  void onAddressChanged(AddressViewModel address) {
    emit(state.maybeMap(
      orElse: () => state,
      loaded: (value) => value.copyWith(
        user: value.user.copyWith(
          address: address,
        ),
      ),
    ));
  }

  Future<void> save({String? newName, String? newProfilePicPath}) async {
    try {
      var result = state.mapOrNull<UserModel>(
        loaded: (value) {
          return _mapToUserModel(value.user);
        },
      );
      if (result == null) {
        return;
      }
      if (newName == result.name) {
        return;
      }
      emit(const EditProfileState.loading());

      result = result.copyWith(
        name: newName ?? result.name,
      );

      if (newProfilePicPath != null) {
        log('newProfilePicPath: $newProfilePicPath');
        final imgUrl = await _imageService.uploadImage(
          imagePath: newProfilePicPath,
          userId: _authService.currentUser!.uid,
        );

        result = result.copyWith(
          profilePicture: imgUrl,
        );
      }

      await _userService.updateUser(result, _authService.currentUser!.uid);
      final newUser = await _userService.getUser(_authService.currentUser!.uid);
      _analyticsService.registerEditPersonalInfoEvent();
      emit(EditProfileState.loaded(
        user: UserViewModel.fromDomain(newUser,
            email: _authService.currentUser!.email),
        success: true,
      ));
    } on AppFailure catch (e, stack) {
      log(e);
      emit(EditProfileState.error(e.message));
      _analyticsService.registerError(e, stack);
    } catch (e, stack) {
      log(e);
      emit(EditProfileState.error(AppFailure.unknown().message));
      _analyticsService.registerError(e, stack);
    }
  }

  void freezeState() {
    log('Freezing state');
    emit(state.maybeMap(
      orElse: () => state,
      loaded: (value) => value.copyWith(
        previousState: value,
      ),
    ));
    log(state);
  }

  Future<void> restoreState() async {
    log('Restoring state');
    emit(state.maybeMap(
      orElse: () => state,
      loaded: (value) => (value.previousState ?? value),
    ));
    emit(state.maybeMap(
      orElse: () => state,
      loaded: (value) => value.copyWith(
        previousState: null,
        needsToClear: true,
      ),
    ));
    log(state);
  }
}

UserModel _mapToUserModel(UserViewModel user) {
  return UserModel(
    name: user.name,
    profilePicture: user.profileImageUrl,
    fullName: user.personalInfo.fullname ?? "",
    cpf: user.personalInfo.cpf ?? "",
    profession: user.personalInfo.profession,
    birthDate: user.personalInfo.birthDate,
    phone: user.personalInfo.phone,
    state: user.personalInfo.state,
    aboutMe: user.personalInfo.aboutMe,
    cep: user.address.cep,
    street: user.address.street,
    number: user.address.number,
    complement: user.address.complement,
    neighborhood: user.address.neighborhood,
    city: user.address.city,
  );
}
