import 'package:sales_platform_app/domain/media/media_model.dart';

abstract class MediaService {
  Future<MediaModel> getMedia(String id);

  Future<List<MediaModel>> getMediaList([String? id]);

  Future<String> getMainVideoUrl({required String url});
}
