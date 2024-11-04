import '../../core/services/api_service.dart';
import '../models/user_model.dart';

class UserRepository {
  static Future<User> registerUser(User user) async {
    final response =
        await ApiService.postRequest('users/register', user.toJson());
    return User.fromJson(response);
  }

  static Future<User> loginUser(String email, String password) async {
    final response = await ApiService.postRequest('users/login', {
      'email': email,
      'password': password,
    });
    return User.fromJson(response);
  }

  static Future<void> logoutUser() async {
    // If your backend has a logout endpoint
    await ApiService.postRequest('users/logout', {});
    // Perform any local logout actions here, such as clearing local tokens
  }

  static Future<User> getUserById(int userId) async {
    final response = await ApiService.getRequest('users/$userId');
    return User.fromJson(response);
  }

  static Future<void> updateUser(User user) async {
    await ApiService.putRequest('users/${user.id}', user.toJson());
  }

  static Future<void> deleteUser(int userId) async {
    await ApiService.deleteRequest('users/$userId');
  }
}
