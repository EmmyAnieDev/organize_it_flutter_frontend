import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../app/config/api_config.dart';

class ApiService {
  static const String _baseUrl = Api.baseURL;

  // Function to handle GET requests
  static Future<dynamic> getRequest(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/$endpoint'));
      return _processResponse(response);
    } catch (e) {
      throw Exception('Error performing GET request: $e');
    }
  }

  // Function to handle POST requests
  static Future<dynamic> postRequest(
      String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      return _processResponse(response);
    } catch (e) {
      throw Exception('Error performing POST request: $e');
    }
  }

  // Function to handle PUT requests
  static Future<dynamic> putRequest(
      String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      return _processResponse(response);
    } catch (e) {
      throw Exception('Error performing PUT request: $e');
    }
  }

  // Function to handle DELETE requests
  static Future<dynamic> deleteRequest(String endpoint) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/$endpoint'));
      return _processResponse(response);
    } catch (e) {
      throw Exception('Error performing DELETE request: $e');
    }
  }

  // Helper function to process HTTP responses
  static dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body); // Successful response
      case 400:
        throw Exception('Bad request: ${response.body}');
      case 401:
        throw Exception('Unauthorized: ${response.body}');
      case 404:
        throw Exception('Not found: ${response.body}');
      case 500:
        throw Exception('Server error: ${response.body}');
      default:
        throw Exception('Unexpected error: ${response.body}');
    }
  }
}
