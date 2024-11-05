import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/api_exception.dart';
import '../models/user_model.dart';
import '../repositories/user_repo.dart';

final userProvider = ChangeNotifierProvider<UserController>((ref) {
  return UserController();
});

class UserController extends ChangeNotifier {
  User? _currentUser;
  User? get currentUser => _currentUser;

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserController() {
    _loadUserFromPreferences();
  }

  Future<void> _loadUserFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('currentUser');
    if (userData != null) {
      _currentUser = User.fromJson(jsonDecode(userData));
      notifyListeners();
    }
  }

  Future<void> _saveUserToPreferences(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentUser', jsonEncode(user.toJson()));
  }

  Future<void> registerUser(BuildContext context) async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      notifyListeners();

      final newUser = User(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      );

      // Register the user and receive user data
      final userData = await UserRepository.registerUser(newUser);
      print(userData);

      // Set the registered user as the current user
      _currentUser = User.fromJson(userData);
      await _saveUserToPreferences(_currentUser!);
      print('Current User Data: $userData');

      await Future.delayed(const Duration(seconds: 5));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful!')),
      );

      context.go('/task-screen');
      clearController();
    } catch (e) {
      String errorMessage = 'Registration failed: ';
      if (e is ApiException) {
        errorMessage += e.message;
      } else {
        errorMessage += e.toString();
      }

      print(errorMessage);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginUser(BuildContext context) async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      notifyListeners();

      final email = emailController.text;
      final password = passwordController.text;

      // Call the repository function to log in and get the user data
      final loggedInUser = await UserRepository.loginUser(email, password);

      // Set the logged-in user as the current user
      _currentUser = loggedInUser;
      await _saveUserToPreferences(_currentUser!);
      print('Logged-in User Data: ${_currentUser?.toJson()}');

      await Future.delayed(const Duration(seconds: 5));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!')),
      );

      context.go('/task-screen');
      clearController();
    } catch (e) {
      String errorMessage = 'Login failed: ';
      if (e is ApiException) {
        errorMessage += e.message;
      } else {
        errorMessage += e.toString();
      }

      print(errorMessage);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logoutUser(BuildContext context) async {
    try {
      await UserRepository.logoutUser();

      _currentUser = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('currentUser');

      context.go('/sign-in');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout successful!')),
      );
    } catch (e) {
      print('Logout failed: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: ${e.toString()}')),
      );
    }
  }

  clearController() {
    emailController.clear();
    nameController.clear();
    passwordController.clear();
  }
}
