import '../../core/services/api_service.dart';
import '../models/task_model.dart';

class TaskRepository {
  static Future<List<Task>> getAllTasks() async {
    final response = await ApiService.getRequest('tasks');
    return (response as List).map((json) => Task.fromJson(json)).toList();
  }

  static Future<Task> getTaskById(int taskId) async {
    final response = await ApiService.getRequest('tasks/$taskId');
    return Task.fromJson(response);
  }

  static Future<void> addTask(Task task) async {
    await ApiService.postRequest('tasks', task.toJson());
  }

  static Future<void> updateTask(Task task) async {
    await ApiService.putRequest('tasks/${task.id}', task.toJson());
  }

  static Future<void> deleteTask(int taskId) async {
    await ApiService.deleteRequest('tasks/$taskId');
  }
}
