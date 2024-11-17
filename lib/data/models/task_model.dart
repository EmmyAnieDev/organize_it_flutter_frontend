import 'package:intl/intl.dart';

class Task {
  final int? id;
  final String name;
  final DateTime? createdAt;
  final DateTime startDate;
  final DateTime endDate;
  final String? category;
  final bool isCompleted;

  Task({
    this.id,
    required this.name,
    this.createdAt,
    required this.startDate,
    required this.endDate,
    this.category,
    this.isCompleted = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'] ?? 'Unnamed Task',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      startDate: DateFormat('yyyy-MM-dd')
          .parse(json['start_date'] ?? DateTime.now().toIso8601String()),
      endDate: DateFormat('yyyy-MM-dd')
          .parse(json['end_date'] ?? DateTime.now().toIso8601String()),
      category: json['category_name']?.toString(),
      isCompleted: json['is_completed'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    final map = {
      'name': name,
      'is_completed': isCompleted ? 1 : 0,
      'start_date': DateFormat('yyyy-MM-dd').format(startDate),
      'end_date': DateFormat('yyyy-MM-dd').format(endDate),
    };

    // Only add category_id if it's not null or empty
    if (category != null && category!.isNotEmpty) {
      map['category'] = category.toString();
    }

    return map;
  }
}
