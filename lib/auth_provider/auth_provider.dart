import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final String baseUrl = 'https://wealthyheels.logic-valley.com/api';
  final String apiKey = 'EX3hAgMaIMjtRDhOoodZXSF8anBDUR';

  bool isLoading = false;

  /// Signup
  Future<void> signup({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    isLoading = true;
    notifyListeners();

    final url = Uri.parse('$baseUrl/guest/signup_email');
    final response = await http.post(
      url,
      headers: {'key': apiKey},
      body: {
        'email': email,
        'password': password,
        'user_type': '2', // normal user
        'first_name': firstName,
        'last_name': lastName,
        'gender': 'male',
        'age': '1990',
      },
    );

    isLoading = false;
    notifyListeners();

    if (response.statusCode != 200) {
      throw Exception('Signup failed: ${response.body}');
    }
  }

  /// Send Verification Email
  Future<void> sendVerificationEmail(String email) async {
    isLoading = true;
    notifyListeners();

    final url = Uri.parse('$baseUrl/guest/send_code_again_email');
    final response = await http.post(
      url,
      headers: {'key': apiKey},
      body: {'email': email},
    );

    isLoading = false;
    notifyListeners();

    if (response.statusCode != 200) {
      throw Exception('Failed to send verification email: ${response.body}');
    }
  }

  /// Verify Email
  Future<void> verifyEmail({
    required String email,
    required String code,
  }) async {
    isLoading = true;
    notifyListeners();

    final url = Uri.parse('$baseUrl/guest/verify_email');
    final response = await http.post(
      url,
      headers: {'key': apiKey},
      body: {
        'email': email,
        'verification_code': code, // correct field name from Postman
      },
    );

    isLoading = false;
    notifyListeners();

    if (response.statusCode != 200) {
      throw Exception('Email verification failed: ${response.body}');
    }
  }

  /// Login
  Future<void> login({
    required String email,
    required String password,
  }) async {
    isLoading = true;
    notifyListeners();

    final url = Uri.parse('$baseUrl/guest/signin_email');
    final response = await http.post(
      url,
      headers: {'key': apiKey},
      body: {
        'email': email,
        'password': password,
      },
    );

    isLoading = false;
    notifyListeners();

    if (response.statusCode == 200) {
      final token = RegExp(r'"token":"(.*?)"').firstMatch(response.body)?.group(1);
      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
      } else {
        throw Exception("Token not found");
      }
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }
}
