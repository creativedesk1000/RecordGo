import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = '127.0.0.1:8000/api/flutter'; // Live Laravel API URL
  
  // Login API call
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('🔐 Attempting login for email: $email');
      print('🌐 API URL: $baseUrl/login');
      
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      print('📡 Login Response Status: ${response.statusCode}');
      print('📡 Login Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Store token in shared preferences
        if (data['token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', data['token']);
          await prefs.setString('user_data', json.encode(data['user']));
          print('✅ Login successful, token stored');
        }
        
        return data;
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Login failed';
        print('❌ Login failed: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Login error: $e');
      throw Exception('Network error: $e');
    }
  }

  // Register API call
  static Future<Map<String, dynamic>> register(String name, String email, String phone, String address, String password) async {
    try {
      print('📝 Attempting registration for email: $email');
      print('🌐 API URL: $baseUrl/register');
      
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'name': name,
          'email': email,
          'phone': phone,
          'address': address,
          'password': password,
          'password_confirmation': password,
        }),
      );

      print('📡 Register Response Status: ${response.statusCode}');
      print('📡 Register Response Body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Store token in shared preferences
        if (data['token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', data['token']);
          await prefs.setString('user_data', json.encode(data['user']));
          print('✅ Registration successful, token stored');
        }
        
        return data;
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Registration failed';
        print('❌ Registration failed: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Registration error: $e');
      throw Exception('Network error: $e');
    }
  }

  // Logout API call
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token != null) {
        print('🚪 Attempting logout with token');
        await http.post(
          Uri.parse('$baseUrl/logout'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );
        print('✅ Logout successful');
      }
      
      // Clear stored data
      await prefs.remove('auth_token');
      await prefs.remove('user_data');
      print('🗑️ Local data cleared');
    } catch (e) {
      print('❌ Logout error: $e');
      // Even if logout fails, clear local data
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_data');
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    print('🔍 Checking login status: ${token != null ? 'Logged in' : 'Not logged in'}');
    return token != null;
  }

  // Get stored user data
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_data');
    if (userDataString != null) {
      final userData = json.decode(userDataString);
      print('👤 Retrieved user data: $userData');
      return userData;
    }
    print('👤 No user data found');
    return null;
  }

  // Get auth token
  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Test API connection
  static Future<bool> testConnection() async {
    try {
      print('🧪 Testing API connection to: $baseUrl');
      final response = await http.get(
        Uri.parse('$baseUrl/test'),
        headers: {
          'Accept': 'application/json',
        },
      );
      print('🧪 Test response: ${response.statusCode} - ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      print('🧪 Test failed: $e');
      return false;
    }
  }
} 