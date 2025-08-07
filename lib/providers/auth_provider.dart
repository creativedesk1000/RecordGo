import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();
  final TextEditingController registerNameController = TextEditingController();
  final TextEditingController registerEmailController = TextEditingController();
  final TextEditingController registerPhoneController = TextEditingController();
  final TextEditingController registerAddressController = TextEditingController();
  final TextEditingController registerPasswordController = TextEditingController();

  bool _isLoggedIn = false;
  Map<String, dynamic>? _userData;
  bool _isLoading = false;

  bool get isLoggedIn => _isLoggedIn;
  Map<String, dynamic>? get userData => _userData;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    _isLoggedIn = await ApiService.isLoggedIn();
    if (_isLoggedIn) {
      _userData = await ApiService.getUserData();
    }
    notifyListeners();
  }

  Future<void> login() async {
    if (loginEmailController.text.isEmpty || loginPasswordController.text.isEmpty) {
      throw Exception('Please fill in all fields');
    }

    // Basic email validation
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(loginEmailController.text)) {
      throw Exception('Please enter a valid email address');
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.login(
        loginEmailController.text.trim(),
        loginPasswordController.text,
      );

      _isLoggedIn = true;
      _userData = response['user'];
      
      // Clear controllers
      loginEmailController.clear();
      loginPasswordController.clear();
      
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw e;
    }
  }

  Future<void> register() async {
    if (registerNameController.text.isEmpty || 
        registerEmailController.text.isEmpty || 
        registerPhoneController.text.isEmpty ||
        registerAddressController.text.isEmpty ||
        registerPasswordController.text.isEmpty) {
      throw Exception('Please fill in all fields');
    }

    // Basic email validation
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(registerEmailController.text)) {
      throw Exception('Please enter a valid email address');
    }

    // Phone validation (basic)
    if (registerPhoneController.text.length < 8) {
      throw Exception('Please enter a valid phone number');
    }

    // Password validation
    if (registerPasswordController.text.length < 6) {
      throw Exception('Password must be at least 6 characters long');
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.register(
        registerNameController.text.trim(),
        registerEmailController.text.trim(),
        registerPhoneController.text.trim(),
        registerAddressController.text.trim(),
        registerPasswordController.text,
      );

      _isLoggedIn = true;
      _userData = response['user'];
      
      // Clear controllers
      registerNameController.clear();
      registerEmailController.clear();
      registerPhoneController.clear();
      registerAddressController.clear();
      registerPasswordController.clear();
      
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw e;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await ApiService.logout();
      _isLoggedIn = false;
      _userData = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw e;
    }
  }

  @override
  void dispose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    registerNameController.dispose();
    registerEmailController.dispose();
    registerPhoneController.dispose();
    registerAddressController.dispose();
    registerPasswordController.dispose();
    super.dispose();
  }
} 