import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sales_platform_app/domain/failure.dart';
import 'package:sales_platform_app/domain/user/insta_service.dart';
import 'package:uuid/uuid.dart';

import '../../domain/util/print.dart';

@Singleton(as: InstaService)
class InstaServiceImpl with Printable implements InstaService {
  final client = Dio();
  final uuid = const Uuid();
  @override
  Future<void> downloadMedia(List<String> url) async {
    try {
      // Download media from url
      log('Getting temp directory...');
      final tempPath = await getTemporaryDirectory();
      // Make so all images are downloaded concurrently
      log('Making all futures');
      final futures = url.map<Future<File?>>((e) async {
        try {
          final response = await client.get(
            e,
            options: Options(
              responseType: ResponseType.bytes,
            ),
          );
          final file = File('${tempPath.path}/${uuid.v4()}.jpg');
          await file.writeAsBytes(response.data);
          return file;
        } catch (e) {
          log('Error downloading media: $e');
          return null;
        }
      }).toList();
      log('Downloading media...');
      final files = await Future.wait(futures);
      // Save media to gallery

      // if all files are null, throw error
      if (files.every((element) => element == null)) {
        throw AppFailure("Não foi possível baixar as fotos");
      }

      for (final file in files) {
        if (file == null) continue;
        log('Saving ${file.path} to gallery...');
        await ImageGallerySaver.saveFile(file.path);
      }

      // If some files are null, throw error
      if (files.any((element) => element == null)) {
        throw AppFailure("Algumas fotos não foram baixadas");
      }
    } catch (e) {
      log(e);
      throw AppFailure("Não foi possível baixar as mídias");
    }
  }
}
