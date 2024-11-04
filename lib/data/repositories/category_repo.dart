import '../../core/services/api_service.dart';
import '../models/category_model.dart';

class CategoryRepository {
  static Future<List<Category>> getAllCategories() async {
    final response = await ApiService.getRequest('categories');
    return (response as List).map((json) => Category.fromJson(json)).toList();
  }

  static Future<Category> getCategoryById(int categoryId) async {
    final response = await ApiService.getRequest('categories/$categoryId');
    return Category.fromJson(response);
  }

  static Future<void> addCategory(Category category) async {
    await ApiService.postRequest('categories', category.toJson());
  }

  static Future<void> updateCategory(Category category) async {
    await ApiService.putRequest('categories/${category.id}', category.toJson());
  }

  static Future<void> deleteCategory(int categoryId) async {
    await ApiService.deleteRequest('categories/$categoryId');
  }
}
