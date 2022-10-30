import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:sales_platform_app/domain/failure.dart';
import 'package:sales_platform_app/domain/image/image_service.dart';
import 'package:sales_platform_app/domain/util/print.dart';
import 'package:sales_platform_app/infrastructure/util/pick_image.dart';
import 'package:uuid/uuid.dart';

@Singleton(as: ImageService)
class ImageServiceImpl with Printable implements ImageService {
  final _storage = FirebaseStorage.instance.ref();
  final uuid = const Uuid();

  @override
  Future<String?> pickImage(ImageSource source) async {
    try {
      log("picking image");
      final result = await pickImageFromPlatform(source);
      return result?.path;
    } catch (err) {
      throw AppFailure("Ocorreu um erro ao selecionar a imagem");
    }
  }

  @override
  Future<String> uploadImage(
      {required String imagePath, required String userId}) async {
    try {
      final file = File(imagePath);
      final fileName = uuid.v4();
      final storagePath =
          _storage.child("profiles/$userId/images/$fileName.jpg");
      log("Uploading image to storage");
      final result = await storagePath.putFile(file);
      // Get the download URL
      log("Getting download url");
      final downloadUrl = await result.ref.getDownloadURL();
      log(downloadUrl);
      return downloadUrl;
    } catch (err) {
      throw AppFailure("Ocorreu um erro ao enviar a imagem");
    }
  }

  @override
  Future<String?> cropImage({required String imagePath}) async {
    log("Cropping image...");
    final croppedFile = await cropImageFromPlatform(imagePath);
    return croppedFile?.path;
  }
}
