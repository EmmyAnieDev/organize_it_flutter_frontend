import 'category_model.dart';
import 'user_model.dart';

class Task {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime dateToStartTask;
  final DateTime dateToEndTask;
  final User user;
  final Category? category;
  final bool isCompleted;

  Task({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.dateToStartTask,
    required this.dateToEndTask,
    required this.user,
    this.category,
    this.isCompleted = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      dateToStartTask: DateTime.parse(json['date_to_start_task']),
      dateToEndTask: DateTime.parse(json['date_to_end_task']),
      user: User.fromJson(json['user']),
      category:
          json['category'] != null ? Category.fromJson(json['category']) : null,
      isCompleted: json['is_completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'date_to_start_task': dateToStartTask.toIso8601String(),
      'date_to_end_task': dateToEndTask.toIso8601String(),
      'user': user.toJson(),
      'category': category?.toJson(),
      'is_completed': isCompleted,
    };
  }
}
