import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:sales_platform_app/application/user/picture_view_model.dart';
import 'package:sales_platform_app/domain/analytics/analytics_service.dart';
import 'package:sales_platform_app/domain/auth/auth_service.dart';
import 'package:sales_platform_app/domain/failure.dart';
import 'package:sales_platform_app/domain/user/insta_service.dart';
import 'package:sales_platform_app/domain/user/user_service.dart';
import 'package:sales_platform_app/domain/util/print.dart';

part 'profile_medias_cubit.freezed.dart';
part 'profile_medias_state.dart';

@injectable
class ProfileMediasCubit extends Cubit<ProfileMediasState> with Printable {
  final AnalyticsService _analyticsService;
  final AuthService _authService;
  final UserService _userService;
  final InstaService _instaService;
  ProfileMediasCubit(this._analyticsService, this._authService,
      this._userService, this._instaService)
      : super(const ProfileMediasState());

  void clear() {
    emit(state.copyWith(error: null, isDownloadingSuccess: false));
  }

  Future<void> loadPictures() async {
    log('Loading pictures...');
    emit(state.copyWith(isLoading: true));
    final user = _authService.currentUser;
    final medias = (await _userService.getPictures(user!.uid))
        .map((e) => PictureViewModel.fromDomain(e))
        .toList();
    log('${medias.length} pictures loaded');
    emit(state.copyWith(pictures: medias, isLoading: false));
  }

  void toggleEditMode(String pictureId) {
    if (state.isEditMode) {
      emit(state.copyWith(isEditMode: false, selectedPictures: []));
    } else {
      emit(state.copyWith(isEditMode: true, selectedPictures: [pictureId]));
    }
  }

  void togglePicture(String pictureId) {
    if (!state.isEditMode) return;
    final selectedPictures = List<String>.from(state.selectedPictures);
    if (selectedPictures.contains(pictureId)) {
      log('removing picture $pictureId');
      selectedPictures.remove(pictureId);
    } else {
      log('adding picture $pictureId');
      selectedPictures.add(pictureId);
    }
    emit(state.copyWith(selectedPictures: selectedPictures));
    if (selectedPictures.isEmpty) {
      emit(state.copyWith(isEditMode: false));
    }
  }

  Future<void> deletePictures() async {
    if (!state.isEditMode) return;
    if (state.selectedPictures.isEmpty) return;
    log('Deleting pictures...');
    try {
      emit(state.copyWith(isLoading: true));
      final user = _authService.currentUser;
      await _userService.deleteImages(
          userId: user!.uid, images: state.selectedPictures);
      emit(state.copyWith(isEditMode: false));
      _analyticsService.registerGridPhotoDeleteEvent();
    } catch (e, stack) {
      log(e);
      emit(state.copyWith(isLoading: false));
      _analyticsService.registerError(e, stack);
    } finally {
      loadPictures();
    }
  }

  Future<void> downloadPictures() async {
    if (!state.isEditMode) return;
    if (state.selectedPictures.isEmpty) return;
    log('Downloading pictures...');
    try {
      emit(state.copyWith(
        isLoading: true,
      ));
      final pictureUrls = state.pictures
          .where((element) => state.selectedPictures.contains(element.id))
          .map((e) => e.url)
          .toList();
      await _instaService.downloadMedia(pictureUrls);
      emit(state.copyWith(
        isDownloadingSuccess: true,
        isLoading: false,
        selectedPictures: [],
        isEditMode: false,
      ));
      _analyticsService.registerGridPhotoDownloadEvent();
    } catch (e, stack) {
      log("Error on dowloadPictures: $e");
      if (e is AppFailure) {
        emit(state.copyWith(
          error: e.message,
          isLoading: false,
        ));
        _analyticsService.registerError(e, stack);
      } else {
        emit(state.copyWith(
          error: AppFailure.unknown().message,
          isLoading: false,
        ));
        _analyticsService.registerError(e, stack);
      }
    }
  }

  Future<void> uploadImage(ImageSource source) async {
    log('Uploading image...');
    final user = _authService.currentUser;
    final imageUrl = await _userService.pickImage(source);
    log('Image uploaded: $imageUrl');
    if (imageUrl == null) {
      return;
    }
    // Crop
    final croppedImage = await _userService.cropImage(imagePath: imageUrl);
    if (croppedImage == null) {
      return;
    }
    log('Cropped image: $croppedImage');
    // Upload
    try {
      emit(state.copyWith(isLoading: true));
      await _userService.uploadImage(
        userId: user!.uid,
        imagePath: croppedImage,
      );
      log('Image uploaded');
      await loadPictures();
      _analyticsService.registerGridPhotoUploadEvent();
    } catch (err, stack) {
      log(err);
      if (err is AppFailure) {
        emit(state.copyWith(error: err.message));
        _analyticsService.registerError(err, stack);
      } else {
        emit(state.copyWith(error: AppFailure.unknown().message));
        _analyticsService.registerError(err, stack);
      }
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
