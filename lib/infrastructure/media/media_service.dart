import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:sales_platform_app/domain/media/media_model.dart';
import 'package:sales_platform_app/domain/util/print.dart';

import '../../domain/media/media_service.dart';

@Singleton(as: MediaService)
class MediaServiceImpl with Printable implements MediaService {
  final _firestore = FirebaseFirestore.instance;
  final _firebaseStorage = FirebaseStorage.instance;

  static const _collection = 'medias';

  @override
  Future<MediaModel> getMedia(String id) async {
    final doc = await _firestore.collection(_collection).doc(id).get();
    return MediaModel.fromJson(doc.id, doc.data()!);
  }

  @override
  Future<List<MediaModel>> getMediaList([String? id]) async {
    final docs = await _firestore
        .collection(_collection)
        .where('enabled', isEqualTo: true)
        .get();
    final medias = <MediaModel>[];
    for (var doc in docs.docs) {
      try {
        if (id != null) {
          // Skip if id is equal to id of current doc
          if (doc.id == id) {
            continue;
          }
        }
        medias.add(MediaModel.fromJson(doc.id, doc.data()));
      } catch (e) {
        log("Error on MediaModel.fromJson: $e");
        continue;
      }
    }
    // Order by order
    medias.sort((a, b) =>
        (a.order ?? double.maxFinite).compareTo(b.order ?? double.maxFinite));
    return medias;
  }

  @override
  Future<String> getMainVideoUrl({required String url}) async {
    // IF url starts with 'http' then it's a valid url
    log(url);
    if (url.startsWith('http')) {
      return url;
    }
    final ref = _firebaseStorage.refFromURL(url);
    return ref.getDownloadURL();
  }
}
