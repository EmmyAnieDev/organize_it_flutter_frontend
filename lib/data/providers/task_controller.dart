import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task_model.dart';
import '../repositories/task_repo.dart';
import '../repositories/user_repo.dart';

final taskProvider = ChangeNotifierProvider<TaskController>((ref) {
  return TaskController();
});

class TaskController extends ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  String? _selectedCategory;
  String? _selectedStatus;
  DateTime? _selectedDate;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get hasFilters =>
      _selectedCategory != null ||
      _selectedStatus != null ||
      _selectedDate != null;

  List<Task> get filteredTasks {
    var filtered = _tasks;
    if (_selectedCategory != null) {
      filtered =
          filtered.where((task) => task.category == _selectedCategory).toList();
    }
    if (_selectedStatus != null) {
      filtered = filtered.where((task) {
        if (_selectedStatus == 'Completed') {
          return task.isCompleted;
        } else if (_selectedStatus == 'Pending') {
          return !task.isCompleted;
        }
        return true;
      }).toList();
    }
    if (_selectedDate != null) {
      filtered = filtered.where((task) {
        return task.dateToEndTask == _selectedDate;
      }).toList();
    }
    return filtered;
  }

  Future<void> fetchTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      final accessToken = await UserRepository.retrieveAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        throw Exception("No access token found. User not logged in.");
      }

      final fetchedTasks = await TaskRepository.getAllTasks(accessToken);
      if (fetchedTasks.isEmpty) {
        print("No tasks available for the user.");
      }

      _tasks = fetchedTasks;
    } catch (e) {
      _errorMessage = "Failed to fetch tasks: ${e.toString()}";
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCategoryFilter(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setStatusFilter(String status) {
    _selectedStatus = status;
    notifyListeners();
  }

  void setDateFilter(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void clearFilters() {
    _selectedCategory = null;
    _selectedStatus = null;
    _selectedDate = null;
    notifyListeners();
  }

  void _setLoadingState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
}
