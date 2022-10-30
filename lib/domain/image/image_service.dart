import 'package:image_picker/image_picker.dart';

abstract class ImageService {
  Future<String?> pickImage(ImageSource source);
  Future<String> uploadImage(
      {required String imagePath, required String userId});
  Future<String?> cropImage({required String imagePath});
}
