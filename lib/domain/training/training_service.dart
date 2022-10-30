import 'package:sales_platform_app/domain/training/category_model.dart';
import 'package:sales_platform_app/domain/training/training_model.dart';

abstract class TrainingService {
  Future<List<CategoryModel>> getCategories();
  Future<CategoryModel> getCategory(String id);

  Future<List<TrainingModel>> getTrainings({String? categoryId});
  Future<TrainingModel> getTraining(String id);
  Future<TrainingModel> getLatestTraining();

  Future<String?> getMainVideoUrl({required String url});
}
