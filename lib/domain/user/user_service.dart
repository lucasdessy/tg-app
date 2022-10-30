import 'package:image_picker/image_picker.dart';
import 'package:sales_platform_app/domain/user/picture_model.dart';
import 'package:sales_platform_app/domain/user/user_model.dart';

abstract class UserService {
  Future<UserModel> getUser(String id);
  Stream<UserModel?> get userStream;
  Future<void> updateUser(UserModel user, String id);
  Future<List<PictureModel>> getPictures(String id);

  Future<String?> pickImage(ImageSource source);
  Future<String?> cropImage({required String imagePath});
  Future<void> uploadImage({required String imagePath, required String userId});
  Future<void> deleteImages(
      {required String userId, required List<String> images});
}
