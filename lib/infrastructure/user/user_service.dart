import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sales_platform_app/domain/failure.dart';
import 'package:sales_platform_app/domain/user/picture_model.dart';
import 'package:sales_platform_app/domain/user/user_model.dart';
import 'package:sales_platform_app/domain/util/print.dart';
import 'package:sales_platform_app/infrastructure/util/pick_image.dart';
import 'package:uuid/uuid.dart';

import '../../domain/user/user_service.dart';

@Singleton(as: UserService)
class UserServiceImpl with Printable implements UserService {
  final _firestore = FirebaseFirestore.instance;
  final _userSubject = BehaviorSubject<UserModel?>();
  final _storage = FirebaseStorage.instance.ref();
  final uuid = const Uuid();

  @override
  Stream<UserModel?> get userStream => _userSubject.stream;

  @override
  Future<UserModel> getUser(String id) async {
    try {
      log('getting user $id...');
      final user = await _firestore.collection('profiles').doc(id).get();
      final userModel = UserModel.fromJson(user.id, user.data()!);
      _userSubject.add(userModel);
      return userModel;
    } catch (e, s) {
      _userSubject.add(null);
      log("Error: $e, StackTrace: $s");
      throw AppFailure("Erro ao buscar usuário");
    }
  }

  @override
  Future<void> updateUser(UserModel user, String id) async {
    try {
      // If property is null, maintain the old value
      final oldUser = await getUser(id);
      final newUser = oldUser.copyWith().toJson();
      for (final key in user.toJson().keys) {
        if (user.toJson()[key] != null) {
          newUser[key] = user.toJson()[key];
        } else {
          log('property $key is null. Keeping old value');
          newUser[key] = oldUser.toJson()[key];
        }
      }
      await _firestore.collection('profiles').doc(id).update(newUser);
    } catch (e) {
      log(e);
      throw AppFailure("Erro ao atualizar usuário");
    }
  }

  @override
  Future<List<PictureModel>> getPictures(String id) async {
    final pictures = <PictureModel>[];
    try {
      final picsDoc = await _firestore
          .collection('profiles')
          .doc(id)
          .collection('pictures')
          .orderBy(
            "createdAt",
            descending: true,
          )
          .get();
      for (final pic in picsDoc.docs) {
        try {
          pictures.add(PictureModel.fromJson(pic.id, pic.data()));
        } catch (e) {
          log('Error parsing picture: $e');
        }
      }
    } catch (e) {
      log('Error getting pictures: $e');
    }
    return pictures;
  }

  @override
  Future<String?> pickImage(ImageSource source) async {
    try {
      final result = await pickImageFromPlatform(source);
      return result?.path;
    } catch (e) {
      log(e);
      throw AppFailure("Erro ao selecionar imagem");
    }
  }

  @override
  Future<void> uploadImage(
      {required String imagePath, required String userId}) async {
    try {
      final file = File(imagePath);
      final fileName = uuid.v4();
      final storagePath =
          _storage.child("profiles/$userId/gridImages/$fileName.jpg");
      log("Uploading image to storage");
      final result = await storagePath.putFile(file);
      // Get the download URL
      log("Getting download url");
      final downloadUrl = await result.ref.getDownloadURL();
      final pictureModel = PictureModel(
        url: downloadUrl,
        createdAt: DateTime.now(),
      );
      final json = pictureModel.toJson();
      // Replace createdAt with server timestamp
      json['createdAt'] = FieldValue.serverTimestamp();
      await _firestore
          .collection('profiles')
          .doc(userId)
          .collection('pictures')
          .add(json);
    } catch (err) {
      throw AppFailure("Ocorreu um erro ao enviar a imagem");
    }
  }

  @override
  Future<String?> cropImage({required String imagePath}) async {
    log("Cropping image...");
    final croppedFile = await cropImageFromPlatform(imagePath, isSquare: true);
    return croppedFile?.path;
  }

  @override
  Future<void> deleteImages(
      {required String userId, required List<String> images}) async {
    try {
      final batch = _firestore.batch();
      for (final image in images) {
        final doc = _firestore
            .collection('profiles')
            .doc(userId)
            .collection('pictures')
            .doc(image);
        batch.delete(doc);
      }
      await batch.commit();
    } catch (e) {
      log(e);
      throw AppFailure("Erro ao deletar imagens");
    }
  }
}
