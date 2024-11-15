import 'package:intl/intl.dart';

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
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unnamed Task',
      createdAt: DateTime.tryParse(json['created_at']) ?? DateTime.now(),
      dateToStartTask: DateFormat('yyyy-MM-dd')
          .parse(json['start_date'] ?? DateTime.now().toIso8601String()),
      dateToEndTask: DateFormat('yyyy-MM-dd')
          .parse(json['end_date'] ?? DateTime.now().toIso8601String()),
      user: User.fromJson(json['user'] ?? {}),
      category:
          json['category'] != null ? Category.fromJson(json['category']) : null,
      isCompleted: json['is_completed'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'start_date': DateFormat('yyyy-MM-dd').format(dateToStartTask),
      'end_date': DateFormat('yyyy-MM-dd').format(dateToEndTask),
      'user': user.toJson(),
      'category': category?.toJson(),
      'is_completed': isCompleted,
    };
  }
}
