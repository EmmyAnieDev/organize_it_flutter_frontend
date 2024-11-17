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
  final searchController = TextEditingController();

  // Task date-related state
  DateTime? _startDate;
  DateTime? _endDate;

  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  // list to store unique categories from tasks
  final Set<String> _categories = {};
  Set<String> get categories => _categories;

  // Loading and error state
  bool _isLoading = false;
  String? _errorMessage;
  String? _selectedCategory;
  String? _selectedStatus;
  DateTime? _selectedDate;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Task list
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  // Add selection related properties
  final Set<int> _selectedTasks = {};
  Set<int> get selectedTasks => _selectedTasks;

  bool isTaskSelected(int taskId) => _selectedTasks.contains(taskId);

  bool get hasFilters =>
      _selectedCategory != null ||
      _selectedStatus != null ||
      _selectedDate != null;

  String _searchQuery = '';

  // Update the filteredTasks getter
  List<Task> get filteredTasks {
    var filtered = _tasks;

    // Apply search filter for both name and category
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((task) {
        final nameMatch = task.name.toLowerCase().contains(query);
        final categoryMatch =
            task.category?.toLowerCase().contains(query) ?? false;
        return nameMatch || categoryMatch;
      }).toList();
    }

    // Apply category filter
    if (_selectedCategory != null) {
      filtered =
          filtered.where((task) => task.category == _selectedCategory).toList();
    }

    // Apply status filter
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

    // Apply date filter
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
      refreshCategorySet();
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
            category: categoryController.text.trim());

        await TaskRepository.addTask(newTask, accessToken);

        // After the task is successfully added, fetch tasks again
        await fetchTasks(ref);

        Navigator.pop(context);
        clearControllers();

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

  //  --------     update task method for the Controller  -------- >
  Future<bool> updateTask(
      BuildContext context, int taskId, WidgetRef ref) async {
    final dateError = validateDates(_startDate, _endDate);

    print(_endDate);

    if (formKey.currentState!.validate() && dateError == null) {
      _setLoadingState(true);

      try {
        final accessToken = await UserRepository.retrieveAccessToken();
        if (accessToken == null || accessToken.isEmpty) {
          throw Exception("No access token found. User not logged in.");
        }

        final updatedTask = Task(
          id: taskId,
          name: taskNameController.text.trim(),
          startDate: _startDate!,
          endDate: _endDate!,
          category: categoryController.text.trim(),
        );

        await TaskRepository.updateTask(updatedTask, accessToken);

        // Refresh the task list
        await fetchTasks(ref);

        Navigator.pop(context);
        clearControllers();

        return true;
      } catch (e) {
        _errorMessage = "Failed to update task: ${e.toString()}";
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

  //  --------     delete task method for the Controller  -------- >
  Future<bool> deleteTask(
      int taskId, BuildContext context, WidgetRef ref) async {
    _setLoadingState(true);
    try {
      final accessToken = await UserRepository.retrieveAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        throw Exception("No access token found. User not logged in.");
      }

      bool deleted = await TaskRepository.deleteTask(taskId, accessToken);

      if (deleted) {
        _tasks.removeWhere((task) => task.id == taskId);
        notifyListeners();
        Navigator.pop(context);
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = "Failed to delete task: ${e.toString()}";
      print(_errorMessage);
      return false;
    } finally {
      _setLoadingState(false);
    }
  }

  //-----------  Method to complete multiple tasks   --------->
  Future<void> completeSelectedTasks(WidgetRef ref) async {
    _setLoadingState(true);

    try {
      final accessToken = await UserRepository.retrieveAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        throw Exception("No access token found. User not logged in.");
      }

      for (final taskId in _selectedTasks) {
        final task = _tasks.firstWhere((t) => t.id == taskId);
        final updatedTask = Task(
          id: taskId,
          name: task.name,
          startDate: task.startDate,
          endDate: task.endDate,
          category: task.category,
          isCompleted: true,
        );

        await TaskRepository.updateTask(updatedTask, accessToken);
      }

      // Refresh tasks after completing
      await fetchTasks(ref);

      clearSelection();
    } catch (e) {
      _errorMessage = "Failed to complete tasks: ${e.toString()}";
      print(_errorMessage);
    } finally {
      _setLoadingState(false);
    }
  }

  // select task checkbox functionality
  void toggleTaskSelection(int taskId) {
    if (_selectedTasks.contains(taskId)) {
      _selectedTasks.remove(taskId);
    } else {
      _selectedTasks.add(taskId);
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedTasks.clear();
    notifyListeners();
  }

// Method to refresh the set of unique categories from the task list
  void refreshCategorySet() {
    _categories.clear();
    for (Task task in _tasks) {
      if (task.category != null && task.category!.isNotEmpty) {
        _categories.add(task.category!);
      }
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
        categoryController.text = task.category!;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = "Failed to load task details: ${e.toString()}";
      print(_errorMessage);
    } finally {
      _setLoadingState(false);
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    searchController.clear();
    _searchQuery = '';
    notifyListeners();
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

  void clearControllers() {
    taskNameController.clear();
    categoryController.clear();
    clearSearch();
    _startDate = null;
    _endDate = null;
  }
}

final taskProvider = ChangeNotifierProvider<TaskController>((ref) {
  return TaskController();
});
