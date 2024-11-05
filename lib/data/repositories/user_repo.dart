import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/services/api_exception.dart';
import '../../core/services/api_service.dart';
import '../models/user_model.dart';

class UserRepository {
  static const _storage = FlutterSecureStorage();

  static Future<Map<String, dynamic>> registerUser(User user) async {
    try {
      final response = await ApiService.postRequest(
          'register.php', user.toJson(includePassword: true));

      if (response is Map<String, dynamic>) {
        if (!response.containsKey('user')) {
          throw ApiException('Invalid response: missing user data');
        }

        // store the access token and refresh token from the function
        if (response.containsKey('access_token') &&
            response.containsKey('refresh_token')) {
          await storeToken(response['access_token'], response['refresh_token']);
        } else {
          throw ApiException('Missing token data in response');
        }

        final userData = response['user'];
        if (userData is Map<String, dynamic>) {
          return {
            'id': userData['id'],
            'name': userData['name'],
            'email': userData['email'],
            'created_at': userData['created_at'],
          };
        } else {
          throw ApiException('Invalid user data format');
        }
      } else {
        throw ApiException('Invalid response format from server');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Registration failed: ${e.toString()}');
    }
  }

  static Future<User> loginUser(String email, String password) async {
    try {
      final response = await ApiService.postRequest('login', {
        'email': email,
        'password': password,
      });

      if (response is Map<String, dynamic>) {
        if (response.containsKey('error')) {
          throw ApiException(response['error']);
        }

        // Store access and refresh tokens if present
        if (response.containsKey('access_token') &&
            response.containsKey('refresh_token')) {
          await storeToken(response['access_token'], response['refresh_token']);
        } else {
          throw ApiException('Missing token data in response');
        }

        return User.fromJson(response['user']);
      } else {
        throw ApiException('Invalid response format from server');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Login failed: ${e.toString()}');
    }
  }

  static Future<void> storeToken(
      String accessToken, String refreshToken) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);

    print("Access Token: $accessToken");
    print("Refresh Token: $refreshToken");
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
