import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../presentation/shared/config.dart';

final ImagePicker _picker = ImagePicker();

Future<XFile?> pickImageFromPlatform(ImageSource source) async {
  return _picker.pickImage(source: source);
}

Future<CroppedFile?> cropImageFromPlatform(String imagePath,
    {bool isSquare = false}) {
  return ImageCropper().cropImage(
    sourcePath: imagePath,
    compressFormat: ImageCompressFormat.jpg,
    maxWidth: 300,
    maxHeight: 300,
    compressQuality: 75,
    aspectRatio: const CropAspectRatio(
      ratioX: 1,
      ratioY: 1,
    ),
    cropStyle: isSquare ? CropStyle.rectangle : CropStyle.circle,
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Editar imagem',
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: true,
        toolbarWidgetColor: Colors.white,
        toolbarColor: SharedConfigs.colors.primary,
        statusBarColor: SharedConfigs.colors.primary,
        activeControlsWidgetColor: SharedConfigs.colors.secondary,
        backgroundColor: Colors.black,
        cropGridColor: Colors.white,
        cropFrameColor: Colors.white,
        dimmedLayerColor: SharedConfigs.colors.tertiary.withOpacity(0.3),
      ),
      IOSUiSettings(
        aspectRatioLockEnabled: true,
        title: "Editar imagem",
        doneButtonTitle: "OK",
        cancelButtonTitle: "Cancelar",
      ),
    ],
  );
}
