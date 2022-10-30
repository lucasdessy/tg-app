import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:sales_platform_app/domain/failure.dart';
import 'package:sales_platform_app/domain/training/category_model.dart';
import 'package:sales_platform_app/domain/training/training_model.dart';
import 'package:sales_platform_app/domain/training/training_service.dart';
import 'package:sales_platform_app/domain/util/print.dart';

@Singleton(as: TrainingService)
class TrainingServiceImpl with Printable implements TrainingService {
  final _firestore = FirebaseFirestore.instance;
  final _firebaseStorage = FirebaseStorage.instance;
  final _functions = FirebaseFunctions.instance;
  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final docs = await _firestore
          .collection('categories')
          .where('enabled', isEqualTo: true)
          .get();
      final categories = <CategoryModel>[];
      for (final doc in docs.docs) {
        categories.add(CategoryModel.fromJson(doc.id, doc.data()));
      }
      // Order by order
      categories.sort((a, b) =>
          (a.order ?? double.maxFinite).compareTo(b.order ?? double.maxFinite));
      return categories;
    } catch (e, s) {
      log("Error getting categories: $e");
      log(s);
      throw AppFailure("Ocorreu um erro ao buscar as categorias");
    }
  }

  @override
  Future<TrainingModel> getTraining(String id) async {
    try {
      final doc = await _firestore.collection('training').doc(id).get();
      return TrainingModel.fromJson(id, doc.data()!);
    } catch (e) {
      log("Error getting training: $e");
      throw AppFailure("Ocorreu um erro ao buscar o treinamento");
    }
  }

  @override
  Future<List<TrainingModel>> getTrainings({String? categoryId}) async {
    try {
      log('getTrainings...');
      final docs = await _firestore
          .collection('training')
          .orderBy(
            "createdAt",
            descending: true,
          )
          .where(
            'enabled',
            isEqualTo: true,
          )
          .get();
      log('got ${docs.docs.length} trainings');
      final trainings = <TrainingModel>[];
      if (categoryId == CategoryModel.latest().id) {
        for (final doc in docs.docs.take(10)) {
          trainings.add(TrainingModel.fromJson(doc.id, doc.data()));
        }
      } else {
        for (final doc in docs.docs) {
          if (categoryId != null) {
            if (doc.data()['category'] != categoryId) {
              continue;
            }
          }
          try {
            final model = TrainingModel.fromJson(doc.id, doc.data());
            trainings.add(model);
          } catch (e, s) {
            log("Error transforming training: ${doc.id} - $e");
            log(s);
            continue;
          }
        }
      }
      return trainings;
    } catch (e) {
      log("Error getting trainings: $e");
      throw AppFailure("Ocorreu um erro ao buscar os treinamentos");
    }
  }

  @override
  Future<TrainingModel> getLatestTraining() async {
    try {
      final docs = await _firestore
          .collection('training')
          .orderBy(
            "createdAt",
            descending: true,
          )
          .where(
            'enabled',
            isEqualTo: true,
          )
          .limit(1)
          .get();
      // Get the latest training
      final doc = docs.docs.first;
      return TrainingModel.fromJson(doc.id, doc.data());
    } catch (e) {
      log("Error getting trainings: $e");
      throw AppFailure("Ocorreu um erro ao buscar os treinamentos");
    }
  }

  @override
  Future<CategoryModel> getCategory(String id) async {
    try {
      if (CategoryModel.latest().id == id) {
        return CategoryModel.latest();
      }
      final doc = await _firestore.collection('categories').doc(id).get();
      return CategoryModel.fromJson(id, doc.data()!);
    } catch (e) {
      log("Error getting category: $e");
      throw AppFailure("Ocorreu um erro ao buscar a categoria");
    }
  }

  @override
  Future<String?> getMainVideoUrl({required String url}) async {
    try {
      if (url.startsWith('http')) {
        return url;
      }
      // If starts with panda:// then convert it using firebase functions
      if (url.startsWith('panda://')) {
        log('Converting panda url to http url...');
        final getPandaVideo = _functions.httpsCallable('getPandaVideo');
        final result = await getPandaVideo({
          "id": url,
        });
        final resultUrl = result.data['playerHlsUrl'];
        log('Converted to $resultUrl');
        return resultUrl;
      }
      final ref = _firebaseStorage.refFromURL(url);
      return ref.getDownloadURL();
    } catch (e) {
      if (e is FirebaseFunctionsException) {
        log("Error getting main video url: ${e.message}");
      } else {
        log("Error getting main video url: $e");
      }
      throw AppFailure("Ocorreu um erro ao buscar o vídeo");
    }
  }
}
