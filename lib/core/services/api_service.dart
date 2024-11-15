import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../app/config/api_config.dart';
import 'api_exception.dart';

class ApiService {
  static const String _baseUrl = Api.baseURL;

  // Function to handle GET requests with Bearer token
  static Future<dynamic> getRequest(String endpoint, {String? token}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      return _processResponse(response);
    } catch (e) {
      throw Exception('Error performing GET request: $e');
    }
  }

  // Function to handle POST requests with Bearer token
  static Future<dynamic> postRequest(String endpoint, Map<String, dynamic> data,
      {String? token}) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      return _processResponse(response);
    } catch (e) {
      throw Exception('Error performing POST request: $e');
    }
  }

  // Function to handle PUT requests with Bearer token
  static Future<dynamic> putRequest(String endpoint, Map<String, dynamic> data,
      {String? token}) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      return _processResponse(response);
    } catch (e) {
      throw Exception('Error performing PUT request: $e');
    }
  }

  // Function to handle DELETE requests with Bearer token
  static Future<dynamic> deleteRequest(String endpoint, {String? token}) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      return _processResponse(response);
    } catch (e) {
      throw Exception('Error performing DELETE request: $e');
    }
  }

  // Helper function to process HTTP responses
  static dynamic _processResponse(http.Response response) {
    final body = response.body;

    try {
      final dynamic decodedResponse = jsonDecode(body);

      switch (response.statusCode) {
        case 200:
        case 201:
          return decodedResponse;
        case 400:
          throw ApiException(decodedResponse['error'] ?? 'Bad request',
              statusCode: 400);
        case 401:
          throw ApiException(decodedResponse['error'] ?? 'Unauthorized',
              statusCode: 401);
        case 404:
          throw ApiException(decodedResponse['error'] ?? 'Not found',
              statusCode: 404);
        case 500:
          throw ApiException(decodedResponse['error'] ?? 'Server error',
              statusCode: 500);
        default:
          throw ApiException(decodedResponse['error'] ?? 'Unexpected error',
              statusCode: response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to process response: ${e.toString()}');
    }
  }
}
