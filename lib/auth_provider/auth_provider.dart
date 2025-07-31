import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final String baseUrl = 'https://wealthyheels.logic-valley.com/api'; 
  final String apiKey = 'EX3hAgMaIMjtRDhOoodZXSF8anBDUR';        

  bool isLoading = false;

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
        'user_type': '2',
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


  Future<void> verifyEmail({
  required String email,
  required String code,
}) async {
  isLoading = true;
  notifyListeners();

  final url = Uri.parse('$baseUrl/guest/verify_email_code');
  final response = await http.post(
    url,
    headers: {'key': apiKey},
    body: {
      'email': email,
      'code': code,
    },
  );

  isLoading = false;
  notifyListeners();

  if (response.statusCode != 200) {
    throw Exception('Email verification failed: ${response.body}');
  }
}



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
