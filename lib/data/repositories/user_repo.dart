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
    try {
      final refreshToken = await _storage.read(key: 'refresh_token');

      await _storage.delete(key: 'access_token');
      await _storage.delete(key: 'refresh_token');
      print("Access and refresh tokens cleared locally.");

      // Only attempt the server logout if there's a refresh token
      if (refreshToken != null) {
        try {
          // Send the refresh token in the request payload
          await ApiService.postRequest('logout.php', {
            'token': refreshToken,
          });

          print("Server logout successful.");
        } catch (e) {
          print(
              "Server logout failed (likely due to expired token): ${e.toString()}");
        }
      } else {
        print("No refresh token found. Local logout complete.");
      }
    } catch (e) {
      print('Logout failed: ${e.toString()}');
      throw ApiException('Logout failed: ${e.toString()}');
    }
  }

  static Future<Map<String, dynamic>> updateUser(User user) async {
    try {
      // Create the payload with required fields
      final Map<String, dynamic> payload = {
        'id': user.id,
        'name': user.name,
        'email': user.email,
      };

      if (user.password != null && user.password!.isNotEmpty) {
        payload['password'] = user.password;
      }

      final response = await ApiService.putRequest('update_user.php', payload);

      if (response == null || response.isEmpty) {
        throw ApiException('No response from server');
      }

      if (response is Map<String, dynamic>) {
        if (response.containsKey('error')) {
          throw ApiException(response['error']);
        }

        if (response['status'] != 'success') {
          throw ApiException('Failed to update profile');
        }

        return response['user'];
      } else {
        throw ApiException('Invalid response format from server');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Update failed: ${e.toString()}');
    }
  }
}
