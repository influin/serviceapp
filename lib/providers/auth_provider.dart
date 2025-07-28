import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _token;
  Map<String, dynamic>? _userData;
  final _dio = Dio();

  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;
  Map<String, dynamic>? get userData => _userData;

  Future<void> setToken(String token) async {
    _token = token;
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> setUserData(Map<String, dynamic> userData) async {
    _userData = userData;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await _dio.post(
        'https://service-899a.onrender.com/api/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        _token = response.data['token'];
        _userData = response.data['data']['user'];
        _isAuthenticated = true;

        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);
        await prefs.setString(
          'user_data',
          response.data['data']['user'] != null
              ? jsonEncode(response.data['data']['user'])
              : '{}',
        );

        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('auth_token')) {
      return;
    }

    final savedToken = prefs.getString('auth_token');
    final savedUserData = prefs.getString('user_data');

    if (savedToken == null || savedUserData == null) return;

    _token = savedToken;
    _userData = jsonDecode(savedUserData) as Map<String, dynamic>?;
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _userData = null;
    _isAuthenticated = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');

    notifyListeners();
  }

  Future<void> refreshUserData() async {
    if (_token == null) return;

    try {
      final response = await _dio.get(
        'https://service-899a.onrender.com/api/auth/me',
        options: Options(headers: {'Authorization': 'Bearer $_token'}),
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        _userData = response.data['data']['user'];
        
        // Update SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_data', jsonEncode(_userData));
        
        notifyListeners();
      }
    } catch (e) {
      print('Error refreshing user data: $e');
    }
  }
}
