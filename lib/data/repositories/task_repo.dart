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

  static Future<Task?> getTaskById(int taskId, String token) async {
    try {
      final response =
          await ApiService.getRequest('tasks/$taskId', token: token);

      if (response == null || response.isEmpty) {
        print("No task found for ID: $taskId");
        return null;
      }

      // Parse the response into a Task model
      return Task.fromJson(response);
    } catch (e) {
      print("Error fetching task by ID: $e");
      rethrow;
    }
  }

  static Future<void> addTask(Task task, String token) async {
    try {
      final response =
          await ApiService.postRequest('tasks', task.toJson(), token: token);

      if (response == null || response.isEmpty) {
        throw Exception("Failed to add task.");
      }
    } catch (e) {
      print("Error adding task: $e");
      rethrow;
    }
  }

  static Future<void> updateTask(Task task, String token) async {
    try {
      final response = await ApiService.putRequest(
        'tasks/${task.id}',
        task.toJson(),
        token: token,
      );

      if (response == null || response.isEmpty) {
        print("Task updated successfully with no content returned.");
        return;
      }

      print("Response: $response");
    } catch (e) {
      print("Error updating task: $e");
      rethrow;
    }
  }

  static Future<void> deleteTask(int taskId, String token) async {
    await ApiService.deleteRequest('tasks/$taskId', token: token);
  }
}
