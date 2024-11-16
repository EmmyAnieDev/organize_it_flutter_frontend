import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/validators.dart';
import '../models/task_model.dart';
import '../repositories/task_repo.dart';
import '../repositories/user_repo.dart';

class TaskController extends ChangeNotifier {
  // Form-related controllers and state variables
  final formKey = GlobalKey<FormState>();
  final taskNameController = TextEditingController();
  final categoryController = TextEditingController();

  // Task date-related state
  DateTime? _startDate;
  DateTime? _endDate;

  // Loading and error state
  bool _isLoading = false;
  String? _errorMessage;
  String? _selectedCategory;
  String? _selectedStatus;
  DateTime? _selectedDate;

  // Task list
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

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
        return task.endDate == _selectedDate;
      }).toList();
    }
    return filtered;
  }

  //  --------     Fetch task method for the Controller  -------- >
  Future<void> fetchTasks(WidgetRef ref) async {
    _setLoadingState(true);

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
      notifyListeners();
    } catch (e) {
      _errorMessage = "Failed to fetch tasks: ${e.toString()}";
      print(_errorMessage);
    } finally {
      _setLoadingState(false);
    }
  }

  //  --------     Get task by ID method for the Controller  -------- >
  Future<Task?> getTaskById(int taskId) async {
    _setLoadingState(true);

    try {
      final accessToken = await UserRepository.retrieveAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        throw Exception("No access token found. User not logged in.");
      }

      // Fetch task by its ID from the repository
      final task = await TaskRepository.getTaskById(taskId, accessToken);

      if (task != null) {
        return task;
      } else {
        _errorMessage = "Task not found";
        notifyListeners();
        return null;
      }
    } catch (e) {
      _errorMessage = "Failed to fetch task by ID: ${e.toString()}";
      print(_errorMessage);
      return null;
    } finally {
      _setLoadingState(false);
    }
  }

  //  --------     Create task method for the Controller  -------- >
  Future<bool> createTask(BuildContext context, WidgetRef ref) async {
    final dateError = validateDates(_startDate, _endDate);

    if (formKey.currentState!.validate() && dateError == null) {
      _setLoadingState(true);

      try {
        final accessToken = await UserRepository.retrieveAccessToken();
        if (accessToken == null || accessToken.isEmpty) {
          throw Exception("No access token found. User not logged in.");
        }

        final newTask = Task(
          name: taskNameController.text.trim(),
          startDate: _startDate!,
          endDate: _endDate!,
        );

        await TaskRepository.addTask(newTask, accessToken);

        // After the task is successfully added, fetch tasks again
        await fetchTasks(ref);

        Navigator.pop(context);
        return true;
      } catch (e) {
        _errorMessage = "Failed to create task: ${e.toString()}";
        print(_errorMessage);
        return false;
      } finally {
        _setLoadingState(false);
      }
    } else {
      _errorMessage = dateError ?? "Please fill out all fields correctly.";
      notifyListeners();
      return false;
    }
  }

  // Methods to handle date selection from the UI
  Future<void> selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      if (isStartDate) {
        _startDate = picked;
      } else {
        _endDate = picked;
      }
      notifyListeners();
    }
  }

  // Asynchronous method designed to load details of a task based on the provided taskId
  Future<void> loadTaskDetails(int taskId) async {
    _setLoadingState(true);

    try {
      final id = taskId;
      final task = await getTaskById(id);

      if (task != null) {
        taskNameController.text = task.name;
        _startDate = task.startDate;
        _endDate = task.endDate;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = "Failed to load task details: ${e.toString()}";
      print(_errorMessage);
    } finally {
      _setLoadingState(false);
    }
  }

  // Methods for task filtering
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

  // Helper method to update loading state
  void _setLoadingState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  // Dispose controllers when no longer needed
  @override
  void dispose() {
    taskNameController.dispose();
    categoryController.dispose();
    super.dispose();
  }
}

final taskProvider = ChangeNotifierProvider<TaskController>((ref) {
  return TaskController();
});
