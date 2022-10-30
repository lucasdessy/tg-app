import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sales_platform_app/domain/download/download_service.dart';
import 'package:sales_platform_app/domain/download/download_type.dart';
import 'package:sales_platform_app/domain/failure.dart';
import 'package:sales_platform_app/domain/media/media_model.dart';
import 'package:sales_platform_app/domain/util/print.dart';

import '../../domain/download/download_state.dart';

@Singleton(as: DownloadService)
class DownloadServiceImpl with Printable implements DownloadService {
  final _firebaseStorage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> _getPermission() async {
    final status = await Permission.storage.status;
    if (status.isDenied) {
      log('Requesting permission...');
      final newStatus = await Permission.storage.request();
      if (newStatus.isGranted) {
        log('Permission granted!');
      } else {
        throw AppFailure(
            'Não foi possível obter permissão para salvar imagens.');
      }
    } else {
      log('Permission already granted!');
    }
  }

  @override
  Stream<DownloadState> download(String id, DownloadType type) async* {
    await _getPermission();
    // Get the media document
    yield const DownloadState();
    try {
      log('Getting media document');
      final mediaDocument = await _firestore.collection('medias').doc(id).get();
      final media =
          MediaModel.fromJson(mediaDocument.id, mediaDocument.data()!);
      // Download the media
      late Reference ref;
      switch (type) {
        case DownloadType.horizontal:
          ref = _firebaseStorage.refFromURL(media.horizontalLink);
          break;
        case DownloadType.story:
          ref = _firebaseStorage.refFromURL(media.storyLink);
          break;
        case DownloadType.feed:
          ref = _firebaseStorage.refFromURL(media.feedLink);
          break;
      }
      final appDocDir = await getTemporaryDirectory();
      final filePath = "${appDocDir.absolute.path}/${ref.fullPath}";
      final file = File(filePath);
      log('Creating directory recursively');
      file.create(recursive: true);
      log('Will save to $filePath');
      log('Downloading media...');
      final writeTask = ref.writeToFile(file);
      bool done = false;
      await for (var taskSnapshot in writeTask.snapshotEvents) {
        switch (taskSnapshot.state) {
          case TaskState.paused:
            log('Download paused');
            done = true;
            break;
          case TaskState.running:
            yield DownloadState(
              progress: taskSnapshot.bytesTransferred / taskSnapshot.totalBytes,
              doneDownloading: false,
            );
            break;
          case TaskState.success:
            yield const DownloadState(
              progress: 1,
              doneDownloading: true,
            );
            done = true;
            break;
          case TaskState.canceled:
            log('Download canceled');
            done = true;
            break;
          case TaskState.error:
            log('Download error');
            done = true;
            throw AppFailure("Ocorreu um erro ao baixar o vídeo.");
        }
        if (done) {
          log('Download done. Exit loop');
          break;
        }
      }
      log('Saving to gallery...');
      await ImageGallerySaver.saveFile(filePath);
      log('this should return the stream');
    } catch (e) {
      log("Errito no infra: $e");
      throw AppFailure("Ocorreu um erro ao baixar o vídeo.");
    }
  }
}
