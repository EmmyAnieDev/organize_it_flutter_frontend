import '../../core/services/api_service.dart';
import '../models/task_model.dart';

class TaskRepository {
  static Future<List<Task>> getAllTasks(String token) async {
    final response = await ApiService.getRequest('tasks', token: token);

    if (response == null || response.isEmpty) {
      print("No tasks returned from API.");
      return [];
    }

    if (response is List) {
      return response
          .map((json) {
            try {
              return Task.fromJson(json);
            } catch (e) {
              print("Error parsing task: $e");
              return null; // Skip invalid tasks
            }
          })
          .whereType<Task>()
          .toList(); // Filter out nulls
    } else {
      throw Exception("Invalid response format from API.");
    }
  }

  static Future<Task> getTaskById(int taskId, String token) async {
    final response = await ApiService.getRequest('tasks/$taskId', token: token);
    return Task.fromJson(response);
  }

  static Future<void> addTask(Task task, String token) async {
    await ApiService.postRequest('tasks', task.toJson(), token: token);
  }

  static Future<void> updateTask(Task task, String token) async {
    await ApiService.putRequest('tasks/${task.id}', task.toJson(),
        token: token);
  }

  static Future<void> deleteTask(int taskId, String token) async {
    await ApiService.deleteRequest('tasks/$taskId', token: token);
  }
}
